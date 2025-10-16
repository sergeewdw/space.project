import Foundation

struct Launch: Decodable {
    let dateUtc: Date
    let rocket: String
    let success: Bool
    let name: String

    enum CodingKeys: CodingKey {
        case dateUtc
        case rocket
        case success
        case name
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dateUtc = try container.decode(Date.self, forKey: .dateUtc)
        self.rocket = try container.decode(String.self, forKey: .rocket)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.name = try container.decode(String.self, forKey: .name)
    }
}

extension Launch {
    struct Launches: Decodable {
        let docs: [Launch]
    }
}
