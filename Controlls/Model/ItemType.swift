import Foundation

enum ItemType: Hashable {
    case image
    case characteristic(SettingsType)
    case info(CellName)
    case stageInfo(stage: Stage, CellStageName)
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

enum Stage: Int, Hashable {
    case first = 1
    case second
}
