import UIKit

struct RocketInfo: Decodable {
    let name: String
    let height, diameter: Measure
    let mass: Mass
    let country: String
    let costPerLaunch: Int
    let firstStage, secondStage: Stage
    let payloadWeights: [PayloadWeight]?
    let id: String
}

extension RocketInfo {
    struct Stage: Decodable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTimeSec: Int?
    }
    struct Measure: Decodable {
        let meters: Double
        let feet: Double
    }
    struct Mass: Decodable {
        let kg: Double
        let lb: Double
    }
    struct PayloadWeight: Decodable {
        let id, name: String
        let kg, lb: Double
    }
}
