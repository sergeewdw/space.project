import Foundation

struct Metric {
    let name: String
    let units: [String]
}
extension Metric {
    struct Settings {
        let metrics: [Metric] = [
            Metric(name: "Высота", units: ["m", "ft"]),
            Metric(name: "Диаметр", units: ["m", "ft"]),
            Metric(name: "Масса", units: ["kg", "lb"]),
            Metric(name: "Полезная нагрузка", units: ["kg", "lb"])
        ]
    }
}
