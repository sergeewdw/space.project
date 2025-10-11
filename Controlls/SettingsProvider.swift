import Foundation

final class SettingsProvider {
    private let defaults = UserDefaults.standard
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    private let key = "saveItems"
    func saveData(_ indexes: [Int]) {
        do {
            let data = try jsonEncoder.encode(indexes)
            defaults.set(data, forKey: key)
        } catch {
            print("Ошибка при сохранении \(error.localizedDescription)")
        }
    }

    func getData() -> [Int] {
        guard let data = defaults.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([Int].self, from: data)
        } catch {
            print("Ошибка при загрузке \(error.localizedDescription)")
            return []
        }
    }
}
