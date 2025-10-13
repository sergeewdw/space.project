import Foundation

final class SettingsProvider {
    private let defaults = UserDefaults.standard
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    func saveUnits(for type: SettingsType, units: SettingsUnits?) {
        let data = try? jsonEncoder.encode(units)
        defaults.set(data, forKey: type.key)
    }

    func getData(for type: SettingsType) -> SettingsUnits {
        guard let data = defaults.data(forKey: type.key) else { return .metric }
        let units = try? jsonDecoder.decode(SettingsUnits.self, from: data)
        return units ?? .metric
    }
}
