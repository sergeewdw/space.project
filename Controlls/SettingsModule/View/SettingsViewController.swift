import UIKit

final class SettingsViewController: UIViewController {
    private var settingsViewModels: [SettingsCellViewModel] = []
    private let settingsProvider: StorageProvider

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 55
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    init(storage: StorageProvider) {
        self.settingsProvider = storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        configureUI()
        setupViews()
        makeConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupNavBar()
    }
}

// MARK: Data Sousrce

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsCell.identifier,
            for: indexPath
        ) as? SettingsCell else {
            return UITableViewCell()
        }

        cell.configureElements(viewModel: settingsViewModels[indexPath.row])
        cell.didChangeIndex = { [weak self] selectedIndex in
            guard let self else { return }
            self.settingsProvider.saveUnits(
                for: self.settingsViewModels[indexPath.row].type,
                units: SettingsUnits(rawValue: selectedIndex)
            )
        }
        return cell
    }
}

// MARK: Table View Delegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: Private

private extension SettingsViewController {
    func configureData() {
        settingsViewModels = SettingsType.allCases.map { SettingsCellViewModel(type: $0, settingsUnits: settingsProvider.getData(for: $0)) }
    }

    func setupViews() {
        view.addSubview(tableView)
    }

    func configureUI() {
        view.backgroundColor = .black
    }

    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupNavBar() {
        title = "Настройки"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationItem.hidesBackButton = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Закрыть",
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }

    @objc
    func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
