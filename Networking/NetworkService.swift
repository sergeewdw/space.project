import UIKit

class NetworkService {
    let rocketInfo = [RocketInfo].self
    let rocketStart = [RocketStart].self
    let rocketURL = "https://api.spacexdata.com/v4/"
    func loadRockets() {
        guard let url = URL(string: rocketURL + "rockets/query") else { return }
        let query: [String: Any] = [
            "query": [
                "payload_weights.id": "leo"
            ],
            "options": [
                "select": [
                    "name": 1,
                    "height": 1,
                    "diameter": 1,
                    "mass": 1,
                    "payload_weights": 1,
                    "country": 1,
                    "cost_per_launch": 1,
                    "first_stage": 1,
                    "second_stage": 1
                ]
            ]
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Connect-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: query, options: [])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error task \(error)")
                return
            }
            guard let data = data else { return }
            struct QueryResult<T: Decodable>: Decodable { let docs: [T] }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(QueryResult<RocketInfo>.self, from: data)
                let rocketsWithLEO = result.docs.first { rocket in
                    rocket.payloadWeights?.contains(where: { $0.id == "leo" }) == true
                }
                print(rocketsWithLEO ?? "nil")
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
        func loadLaunches() {
            guard let url = URL(string: rocketURL + "launches") else { return  }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error ?? "error")
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let rokets = try JSONDecoder().decode([RocketStart].self, from: data)
                    print(rokets)
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
