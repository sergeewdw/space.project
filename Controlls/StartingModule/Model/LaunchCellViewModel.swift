import Foundation

struct LaunchCellViewModel {
    let name: String
    let dateUtc: Date?
    let success: Bool

    init(from launch: Launch) {
        self.name = launch.name
        self.success = launch.success
        self.dateUtc = launch.dateUtc
    }
}
