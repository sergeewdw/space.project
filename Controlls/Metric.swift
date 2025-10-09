import Foundation
enum Metric: String, CaseIterable {
    case height = "Высота"
    case diameter = "Диаметр"
    case mass = "Масса"
    case usefulLoad = "Полезная нагрузка"
}

enum Unit {
    static let units = ["m", "ft"]
    static let unitsMass = ["kg", "lb"]
}
