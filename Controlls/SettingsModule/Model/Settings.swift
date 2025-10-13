import Foundation

struct SettingsCellViewModel {
    let type: SettingsType
    let settingsUnits: SettingsUnits
}

enum SettingsType: String, CaseIterable {
    enum SettingsDimension: String {
        case m, ft, kg, lb
    }

    case height = "Высота"
    case diameter = "Диаметр"
    case mass = "Масса"
    case payloadWeight = "Полезная нагрузка"

    var metricDimension: SettingsDimension {
        switch self {
        case .height, .diameter:
                .m
        case .mass, .payloadWeight:
                .kg
        }
    }

    var imperialDimension: SettingsDimension {
        switch self {
        case .height, .diameter:
                .ft
        case .mass, .payloadWeight:
                .lb
        }
    }

    var key: String {
        switch self {
        case .height:
            "userDefaults.settings.height"
        case .diameter:
            "userDefaults.settings.diameter"
        case .mass:
            "userDefaults.settings.mass"
        case .payloadWeight:
            "userDefaults.settings.payloadWeight"
        }
    }
}

enum SettingsUnits: Int, Codable {
    case metric
    case imperial
}
