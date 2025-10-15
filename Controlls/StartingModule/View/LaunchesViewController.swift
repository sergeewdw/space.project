import UIKit

final class LaunchesViewController: UIViewController {
    private var items: [LaunchCellViewModel] = []
    private let network = NetworkService()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setupCompositionalLayout())
        view.register(RocketCell.self, forCellWithReuseIdentifier: RocketCell.identifier)
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getLaunches()
        setupViews()
        makeConstaraints()
        nameRocketView()
    }
}

// MARK: Data Source

extension LaunchesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RocketCell.identifier, for: indexPath) as? RocketCell else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - Private

private extension LaunchesViewController {
    func setupViews() {
        view.addSubview(collectionView)
    }

    func getLaunches() {
        network.getLaunches(by: "5e9d0d95eda69955f709d1eb") {  [weak self] result in
            switch result {
            case let .success(items):
                DispatchQueue.main.async {
                    self?.items = items.docs.map { LaunchCellViewModel(from: $0) }
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func makeConstaraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(105)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(105)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)

        return UICollectionViewCompositionalLayout(section: section)
    }

    func nameRocketView() {
        navigationItem.title = "Falcon 1"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
