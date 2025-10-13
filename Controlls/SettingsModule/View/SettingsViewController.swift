import UIKit

final class SettingsViewController: UIViewController {
    private var settingsViewModels: [SettingsCellViewModel] = []
    private let settingsProvider = StorageProvider()

    private let titleLabel: UILabel = {
        let textSettings = "Настройки"
        let label = UILabel()
        label.text = textSettings
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var clousePressedButton: UIButton = {
        let textExit = "Закрыть"
        let closeButton = UIButton(type: .system)
        closeButton.setTitle(textExit, for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        configureUI()
        setupViews()
        makeConstraints()
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
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(clousePressedButton)
    }

    func configureUI() {
        view.backgroundColor = .black
    }

    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),

            clousePressedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            clousePressedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }

    @objc
    func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
