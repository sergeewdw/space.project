import UIKit

final class ThirdViewController: UIViewController {
    private let metric = Metric.allCases
    private let units = ["m", "ft"]
    private let unitsMass = ["kg", "lb"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        settingView()
        clouseButton()
        creatTableView()
    }
    enum Metric: String, CaseIterable {
        case height = "Высота"
        case diameter = "Диаметр"
        case mass = "Масса"
        case usefulLoad = "Полезная нагрузка"
    }
    // MARK: Table View
    private func creatTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    // MARK: Option View
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
    // MARK: Segmented Controll
    private func createSegmentedControl(for metricItem: Metric) -> UISegmentedControl {
        let currentUnits: [String]
        switch metricItem {
        case .height, .diameter:
            currentUnits = units
        case .mass, .usefulLoad:
            currentUnits = unitsMass
        }
        let segmentControl = UISegmentedControl(items: currentUnits)
        segmentControl.backgroundColor = .systemGray4
        segmentControl.selectedSegmentTintColor = .white
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentControl.accessibilityIdentifier = metricItem.rawValue
        let savedIndex = UserDefaults.standard.integer(forKey: metricItem.rawValue)
        segmentControl.selectedSegmentIndex = savedIndex
        return segmentControl
    }
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let metricName = sender.accessibilityIdentifier!
        let selectedIndex = sender.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: metricName)
        print("Сохранено")
    }
}
// MARK: Data Sousrce
extension ThirdViewController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        metric.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let metricItem = metric[indexPath.row]
        cell.textLabel?.text = metricItem.rawValue
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        let segmentControl = createSegmentedControl(for: metricItem)
        cell.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -40),
            segmentControl.topAnchor.constraint(equalTo: cell.topAnchor, constant: 8),
            segmentControl.widthAnchor.constraint(equalToConstant: 100),
            segmentControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        return cell
    }
}
// MARK: Table View Delegate
extension ThirdViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
