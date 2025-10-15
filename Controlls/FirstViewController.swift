import UIKit

final class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeActionButton()
        startButton()
    }
    private func configureUI() {
        view.backgroundColor = .white
    }

    private func makeActionButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.setTitle("Настройки", for: .normal)
        button.configuration?.baseBackgroundColor = .black
        button.configuration?.baseForegroundColor = .white
        button.configuration?.contentInsets = .init(top: 12, leading: 20, bottom: 12, trailing: 20)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        let action = UIAction(title: "Настройки") { [weak self] _ in
            let settingVC = SettingsViewController()
            settingVC.modalPresentationStyle = .formSheet
            self?.present(settingVC, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
    }

    private func startButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.setTitle("Запуски", for: .normal)
        button.configuration?.baseBackgroundColor = .black
        button.configuration?.baseForegroundColor = .white
        button.configuration?.contentInsets = .init(top: 12, leading: 20, bottom: 12, trailing: 20)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
        let action = UIAction { [weak self] _ in
            let launchVC = LaunchesViewController()
            self?.navigationController?.pushViewController(launchVC, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
    }
}
