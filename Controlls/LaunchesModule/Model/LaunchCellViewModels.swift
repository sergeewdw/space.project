import Foundation

struct LaunchCellViewModels {
    let name: String
    let dateUtc: Date
    let success: Bool

    init(from launch: Launches) {
        self.name = launch.name
        self.success = launch.success
        self.dateUtc = launch.dateUtc
    }
}
