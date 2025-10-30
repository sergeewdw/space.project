import UIKit
import Kingfisher

final class RocketViewController: UIViewController {
    var rocketInfo: RocketInfo
    private let storage: StorageProvider
    private lazy var collectionView: UICollectionView = makeCollectionView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemType>?

    init(rocket: RocketInfo, storage: StorageProvider) {
        self.rocketInfo = rocket
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = makeDataSource()
        applySnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySnapshot()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Diffable Data Source

private extension RocketViewController {
    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        collectionView.register(CharacteristicsCell.self, forCellWithReuseIdentifier: CharacteristicsCell.identifier)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(InfoCell.self, forCellWithReuseIdentifier: InfoCell.identifier)
        collectionView.register(Header.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: Header.identifier)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.identifier)
        return collectionView
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, ItemType> {
        let dataSource = UICollectionViewDiffableDataSource<Section,ItemType>(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifire in
            switch itemIdentifire {
            case .image:
                return self.configureImageCell(indexPath)
            case .info:
                return self.configureInfoCell(indexPath)
            case .characteristic:
                return self.configureCharacteristicsCell(indexPath)
            case .stageInfo(let isFirst, _):
                return self.configureStageCell(indexPath, isFirst: isFirst)
            case .button:
                return self.configureButtonCell(indexPath)
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind, withReuseIdentifier: Header.identifier, for: indexPath
                  ) as? Header else {
                return UICollectionReusableView()
            }
            let section = Section.allCases[indexPath.section]
            var textLabel: String = ""

            switch section {
            case .infoFirstStage:
                textLabel = "ПЕРВАЯ СТУПЕНЬ"
            case .infoSecondStage:
                textLabel = "ВТОРАЯ СТУПЕНЬ"
            default:
                textLabel = ""
            }
            header.configure(textLabel)
            return header
        }
        return dataSource
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>()
        snapshot.appendSections([.image, .characteristics, .info, .infoFirstStage, .infoSecondStage, .button])
        snapshot.appendItems([.image], toSection: .image)
        snapshot.appendItems(
            SettingsType.allCases.map { .characteristic($0) },
            toSection: .characteristics
        )
        snapshot.appendItems(
            CellName.allCases.map { .info($0) },
            toSection: .info
        )
        snapshot.appendItems(
            CellStageName.allCases.map { .stageInfo(isFirst: true, $0) },
            toSection: .infoFirstStage
        )
        snapshot.appendItems(
            CellStageName.allCases.map { .stageInfo(isFirst: false, $0) },
            toSection: .infoSecondStage
        )
        snapshot.appendItems([.button], toSection: .button)
        dataSource?.apply(snapshot, animatingDifferences: true)

        var reconfigure = dataSource?.snapshot() ?? snapshot
        let itemsToReconfigure = reconfigure.itemIdentifiers(inSection: .characteristics)
        reconfigure.reconfigureItems(itemsToReconfigure)
        dataSource?.apply(reconfigure, animatingDifferences: false)
    }
}

// MARK: - Configure Elements

private extension RocketViewController {
    func configureCharacteristicsCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacteristicsCell.identifier,
            for: indexPath) as? CharacteristicsCell
        else {
            return UICollectionViewCell()
        }

        let type = SettingsType.allCases[indexPath.row]
        let unitForCurrentType = storage.getData(for: type)
        let value: Double
        let unitString: String = (unitForCurrentType == .metric) ? type.metricDimension.rawValue : type.imperialDimension.rawValue

        switch type {
        case .height:
            value = unitForCurrentType == .metric ? rocketInfo.height.meters : rocketInfo.height.feet
        case .diameter:
            value = unitForCurrentType == .metric ? rocketInfo.diameter.meters : rocketInfo.diameter.feet
        case .mass:
            value = unitForCurrentType == .metric ? rocketInfo.mass.kg : rocketInfo.mass.lb
        case .payloadWeight:
            value = (unitForCurrentType == .metric ? rocketInfo.payloadWeights?.first?.kg : rocketInfo.payloadWeights?.first?.lb) ?? 0
        }

        cell.configure(.init(value: value, title: type.rawValue , units:  unitString))
        return cell
    }

    func configureImageCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCell.identifier,
            for: indexPath) as? ImageCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(rocketInfo)
        cell.onSettingsTap = { [weak self] in
            guard let self else { return }
            let viewController = SettingsViewController(storage: self.storage)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        return cell
    }

    func configureInfoCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: InfoCell.identifier,
            for: indexPath) as? InfoCell
        else {
            return UICollectionViewCell()
        }
        let value: String
        let title = CellName.allCases[indexPath.row].rawValue
        switch indexPath.row {
        case 0:
            value = formatFirstFlight(rocketInfo.firstFlight)
        case 1:
            value = rocketInfo.country ?? ""
        case 2:
            value = String(format: "$%.0f mln", Double(rocketInfo.costPerLaunch) / 1_000_000)
        default:
            return cell
        }
        cell.configure(.init(value: value, title: title))
        return cell
    }

    func configureStageCell(_ indexPath: IndexPath, isFirst: Bool) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: InfoCell.identifier,
            for: indexPath) as? InfoCell
        else {
            return UICollectionViewCell()
        }
        let stage = isFirst ? rocketInfo.firstStage : rocketInfo.secondStage
        let title = CellStageName.allCases[indexPath.row].rawValue
        let value: String
        switch indexPath.row {
        case 0: value = "\(stage.engines)"
        case 1: value = "\(stage.fuelAmountTons) ton"
        case 2: value = stage.burnTimeSec.map { "\($0) sec" } ?? "0 sec"
        default: return cell
        }
        cell.configure(.init(value: value, title: title))
        return cell
    }

    func configureButtonCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ButtonCell.identifier,
            for: indexPath) as? ButtonCell
        else {
            return UICollectionViewCell()
        }
        cell.onStartingsTap = { [weak self] in
            guard let self = self else { return }
            let viewController = LaunchesViewController(rocket: self.rocketInfo)
            navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.pushViewController(viewController, animated: true)}
        return cell
    }
}

// MARK: Private

private extension RocketViewController {
    func formatFirstFlight(_ date: String?) -> String {
        guard let date = date else { return " " }
        let inoutFormatter = DateFormatter()
        inoutFormatter.locale = Locale(identifier: "en_US_POSIX")
        inoutFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inoutFormatter.date(from: date) else { return date }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ru_RU")
        outputFormatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        return outputFormatter.string(from: date)
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return self?.collectionView.sectionImage()
            case 1:
                return self?.collectionView.sectionLayoutMetric()
            case 2:
                return self?.collectionView.sectionInfo(showHeader: false)
            case 3,4:
                return self?.collectionView.sectionInfo(showHeader: true)
            case 5:
                return self?.collectionView.sectionButton()
            default:
                return nil
            }
        }
        return layout
    }
}
