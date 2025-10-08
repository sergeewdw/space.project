import UIKit

final class SettingViewController: UIViewController {
    private let metric = Metric.allCases
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        settingView()
        clouseButton()
        creatTableView()
    }
    // MARK: Table View
    private func creatTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    // MARK: Setting View
    private func settingView() {
        let titelLabel = UILabel()
        titelLabel.text = "Настройки"
        titelLabel.textColor = .white
        titelLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        titelLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titelLabel)
        NSLayoutConstraint.activate([
            titelLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titelLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    // MARK: Action
    private func clouseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        let metricItem = metric[indexPath.row]
        cell.configure(with: metricItem)
        return cell
    }
}
// MARK: Table View Delegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
