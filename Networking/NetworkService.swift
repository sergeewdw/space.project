import UIKit

final class NetworkService {
    typealias RocketResult = (Result<[RocketInfo], Error>) -> Void
    typealias LaunchResult = (Result<Launch.Launches, Error>) -> Void
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
    func getRockets(completionHandler: @escaping RocketResult) {
        guard let url = URL(string: Constants.rocketURL + "rockets") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completionHandler(.failure(error))
            }
            guard let data = data else { return }
            do {
                let result = try self.rocketDecoder.decode([RocketInfo].self, from: data)
                completionHandler(.success(result))
            } catch {
                completionHandler(.failure(error))
            }
        }.resume()
    }
    func getLaunches(by rocketId: String, completionHandler: @escaping LaunchResult) {
        guard let url = URL(string: Constants.rocketURL + "launches/query") else { return }
        var request = URLRequest(url: url)
        let body = LaunchRequest(query: .init(rocket: rocketId, upcoming: false), options: .init(limit: 200, sort: "-date_local"))
        let encodedBody = try? JSONEncoder().encode(body)
        request.httpMethod = "POST"
        request.httpBody = encodedBody
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completionHandler(.failure(error))
            }
            guard let data = data else { return }
            do {
                let result = try self.launchesDecoder.decode(Launch.Launches.self, from: data)
                completionHandler(.success(result))
            } catch {
                completionHandler(.failure(error))
            }
        }.resume()
    }
}
extension NetworkService {
    enum Constants {
        static let rocketURL = "https://api.spacexdata.com/v4/"
    }
}
