import UIKit

class LaunchesViewController: UIViewController {
    private var items: [Launch] = []
    private let network = NetworkService()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
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
                    self?.items = items.docs
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

    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 390, height: 105)
        layout.minimumLineSpacing = 0
        return layout
    }

    func nameRocketView() {
        navigationItem.title = "Falcon 1"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
