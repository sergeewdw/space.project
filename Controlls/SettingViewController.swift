import UIKit

final class SettingViewController: UIViewController {
    private let metric = Metric.allCases
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Настройки"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let clousePressedButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.dataSource = self
        tableView.delegate = self
        setupView()
        setupButton()
        setupTableView()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
    }
    
// MARK: Table View
    
    private func setupTableView() {
        view.addSubview(tableView)
        makeConstraintsTableView()
    }
    
    private func makeConstraintsTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
// MARK: Setting View
    
    private func setupView() {
        view.addSubview(titleLabel)
        makeConstraintsView()
    }
    
    private func makeConstraintsView() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
// MARK: Action
    
    private func setupButton() {
        view.addSubview(clousePressedButton)
        clousePressedButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        makeConstraintsButton()
    }
    
    private func makeConstraintsButton() {
        NSLayoutConstraint.activate([
            clousePressedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            clousePressedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Data Sousrce

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        metric.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        let metricItem = metric[indexPath.row]
        cell.configureElements(with: metricItem)
        return cell
    }
}
// MARK: Table View Delegate

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
