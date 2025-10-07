import UIKit

final class NetworkService {
    private let launchesDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
    private let rocketDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    let rocketURL = "https://api.spacexdata.com/v4/"
    func getRockets(errorHandler: @escaping (Result<[RocketInfo], Error>) -> Void) {
        guard let url = URL(string: rocketURL + "rockets") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
            }
            guard let data = data else { return }
            do {
                let result = try self.rocketDecoder.decode([RocketInfo].self, from: data)
                errorHandler(.success(result))
            } catch {
                errorHandler(.failure(error))
            }
        }.resume()
    }
    func getLaunches(by rocketId: String, errorHandler: @escaping (Result<Launches, Error>) -> Void) {
        guard let url = URL(string: rocketURL + "launches/query") else { return }
        var request = URLRequest(url: url)
        let body = LaunchRequest(query: .init(rocket: rocketId, upcoming: false), options: .init(limit: 200, sort: "-date_local"))
        let encodedBody = try? JSONEncoder().encode(body)
        request.httpMethod = "POST"
        request.httpBody = encodedBody
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching data: \(error)")
            }
            guard let data = data else { return }
            do {
                let result = try self.launchesDecoder.decode(Launches.self, from: data)
                errorHandler(.success(result))
            } catch {
                errorHandler(.failure(error))
            }
        }.resume()
    }
}
