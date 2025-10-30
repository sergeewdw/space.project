import Foundation

struct InfoCellViewModels {
    let value: String
    let title: String
}

enum CellName: String, CaseIterable {
    case firstFlight = "Первый запуск"
    case country = "Страна"
    case costPerLaunch = "Стоимость запуска"
}

enum CellStageName: String, CaseIterable {
    case engines = "Количество двигателей"
    case fuelAmountTons = "Количество топлива"
    case burnTimeSec = "Время сгорания"
}
