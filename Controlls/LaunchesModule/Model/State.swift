import Foundation

enum State {
    case launches(Launches.Launch)
    case empty
    case error(Error)
}
