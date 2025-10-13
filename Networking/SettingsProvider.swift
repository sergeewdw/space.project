import Foundation

final class SettingsProvider {
    private let userDefaults = UserDefaults.standard
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    func saveUnits(for type: SettingsType, units: SettingsUnits?) {
        let data = try? jsonEncoder.encode(units)
        userDefaults.set(data, forKey: type.key)
    }

    func getData(for type: SettingsType) -> SettingsUnits {
        guard let data = userDefaults.data(forKey: type.key) else { return .metric }
        let units = try? jsonDecoder.decode(SettingsUnits.self, from: data)
        return units ?? .metric
    }
}
