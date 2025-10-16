import Foundation

struct Launch: Decodable {
    let dateUtc: Date
    let rocket: String
    let success: Bool
    let name: String
}

extension Launch {
    struct Launches: Decodable {
        let docs: [Launch]
    }
}
