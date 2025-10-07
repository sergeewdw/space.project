import Foundation

struct LaunchRequest: Encodable {
    let query: Query
    let options: Options
}

extension LaunchRequest {
    struct Query: Encodable {
        let rocket: String
        let upcoming: Bool
    }
    struct Options: Encodable {
        let limit: Int
        let sort: String
    }
}
