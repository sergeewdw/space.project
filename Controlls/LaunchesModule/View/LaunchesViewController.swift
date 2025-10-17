import UIKit

final class LaunchesViewController: UIViewController {
    private var viewModels: [LaunchCellVIewModels] = []
    private let networkService = NetworkService()

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
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
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
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchesCell.identifier, for: indexPath) as? LaunchesCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}

// MARK: - Private

private extension LaunchesViewController {
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.addSubview(activityIndicator)
        collectionView.addSubview(placeholderLabel)
    }

    func getLaunches() {
        self.activityIndicator.startAnimating()
        networkService.getLaunches(by: "5e9d0d95eda69973a809d1ec") {  [weak self] result in
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
            self.viewModels = items.docs.map { LaunchCellVIewModels(from: $0) }
            self.collectionView.reloadData()
        case .empty:
            displayLabel(text: "No launches have been made yet.")
        case .error(let error):
            displayLabel(text: error.localizedDescription)
        }
    }

    func displayLabel(text: String) {
            self.placeholderLabel.text = text
    }

    func makeConstaraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            placeholderLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(greaterThanOrEqualTo: collectionView.leadingAnchor, constant: 24),
            placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: collectionView.trailingAnchor, constant: -24),

            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
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

// MARK: State

extension LaunchesViewController {
    enum State {
        case launches(Launches)
        case empty
        case error(Error)
    }
}
