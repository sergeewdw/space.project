import UIKit

final class LaunchesViewController: UIViewController {
    private var items: [LaunchCellViewModel] = []
    private let network = NetworkService()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setupCompositionalLayout())
        view.register(LaunchesCell.self, forCellWithReuseIdentifier: LaunchesCell.identifier)
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let cellType: UIView = {
        let view = UIView()
        return view
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        makeConstaraints()
        nameRocketView()
        getLaunches()
    }
}

// MARK: Data Source

extension LaunchesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchesCell.identifier, for: indexPath) as? LaunchesCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

// MARK: - Private

private extension LaunchesViewController {
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.backgroundView = cellType
        cellType.addSubview(activityIndicator)
        cellType.addSubview(placeholderLabel)
    }

    func getLaunches() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }

        self.activityIndicator.startAnimating()
        network.getLaunches(by: "5e9d0d95eda69955f709d1eb") {  [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case let .success(items):
                    guard !items.docs.isEmpty else {
                        self?.displayView(.empty)
                        return
                    }
                    self?.displayView(.launches(items))
                case .failure(let error):
                    self?.displayView(.error(error))
                }
            }
        }
    }

    func displayView(_ state: State) {
        switch state {
        case .launches(let items):
            self.items = items.docs.map { LaunchCellViewModel(from: $0) }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case .empty:
            displayLabel(text: "No launches have been made yet.")
        case .error:
            displayLabel(text: "The network data is invalid.")
        }
    }

    func displayLabel(text: String) {
        DispatchQueue.main.async {
            self.placeholderLabel.text = text
        }
    }

    func makeConstaraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            placeholderLabel.centerXAnchor.constraint(equalTo: cellType.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: cellType.centerYAnchor)
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
    }
}
