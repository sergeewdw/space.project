import UIKit
import Kingfisher

protocol RocketScreenDelegate: AnyObject {
    func didTapSettings()
    func didTapStartLaunches()
}

final class RocketViewController: UIViewController {
    private var rocketInfo: RocketInfo
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
        print(#function, Self.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySnapshot()
        navigationController?.setNavigationBarHidden(true, animated: false)
        print(#function, Self.self, "animated =", animated)
    }

    override func loadView() {
        super.loadView()
        print(#function, Self.self)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        print(#function, Self.self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(#function, Self.self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(#function, Self.self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function, Self.self, "animated =", animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function, Self.self, "animated =", animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function, Self.self, "animated =", animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function, Self.self)
    }

    @available(iOS 13.0, *)
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        print(#function, Self.self, "animated =", animated)
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
            case .stageInfo(let stage, _):
                return self.configureStageCell(indexPath, stage: stage)
            case .button:
                return self.configureButtonCell(indexPath)
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: Header.identifier,
                for: indexPath
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
            CellStageName.allCases.map { .stageInfo(stage: .first, $0) },
            toSection: .infoFirstStage
        )
        snapshot.appendItems(
            CellStageName.allCases.map { .stageInfo(stage: .second, $0) },
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
        cell.delegate = self
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

    func configureStageCell(_ indexPath: IndexPath, stage: Stage) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: InfoCell.identifier,
            for: indexPath) as? InfoCell
        else {
            return UICollectionViewCell()
        }
        let stage = (stage == .first) ? rocketInfo.firstStage : rocketInfo.secondStage
        let title = CellStageName.allCases[indexPath.row].rawValue
        let value: String
        switch indexPath.row {
        case 0: value = "\(stage.engines)"
        case 1: value = "\(stage.fuelAmountTons) ton"
        case 2: value = stage.burnTimeSec.map { "\($0) sec" } ?? "0 sec"
        default: return cell
        }
        cell.configure(.init(value: value, title: title))
        let attributed = NSMutableAttributedString(string: value)

        if let unit = ["ton", "sec"].first(where: { value.hasSuffix(" " + $0) }),
           let range = value.range(of: unit) {
            let nsRange = NSRange(range, in: value)
            attributed.addAttribute(.foregroundColor,
                                    value: UIColor.systemGray2,
                                    range: nsRange)
        }

        cell.configure(title: title, attributedValue: attributed)
        return cell
    }

    func configureButtonCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ButtonCell.identifier,
            for: indexPath) as? ButtonCell
        else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        return cell
    }
}

private extension RocketViewController {
    func sectionLayoutMetric() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

    func sectionImage() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(400))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

    func sectionInfo(showHeader: Bool) -> NSCollectionLayoutSection {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .zero
        let section = NSCollectionLayoutSection(group: group)
        if showHeader {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        return section
    }

    func sectionButton() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .zero
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        return section
    }
}

extension RocketViewController: RocketScreenDelegate {
    func didTapSettings() {
        let viewController = SettingsViewController(storage: storage)
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .automatic
        present(nav, animated: true)
    }

    func didTapStartLaunches() {
        let viewModel = LaunchesViewModel(rocketName: rocketInfo.name, rocketId: rocketInfo.id)
        let viewController = LaunchesViewController(launches: viewModel)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(viewController, animated: true)
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
            switch Section.allCases[section] {
            case .image:
                return self?.sectionImage()
            case .characteristics:
                return self?.sectionLayoutMetric()
            case .info:
                return self?.sectionInfo(showHeader: false)
            case .infoFirstStage, .infoSecondStage:
                return self?.sectionInfo(showHeader: true)
            case .button:
                return self?.sectionButton()
            }
        }
        return layout
    }
}
