import Foundation

enum ItemType: Hashable {
    case image
    case characteristic(SettingsType)
    case info(CellName)
    case stageInfo(isFirst: Bool, CellStageName)
    case button
}

enum Section: CaseIterable, Hashable {
    case image
    case characteristics
    case info
    case infoFirstStage
    case infoSecondStage
    case button
}
