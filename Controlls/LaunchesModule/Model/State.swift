import Foundation

enum State {
    case launches(Launch.Launches)
    case empty
    case error(Error)
}
