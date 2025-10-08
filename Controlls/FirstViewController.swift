import UIKit

class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        actionButton()
    }
    func actionButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.setTitle("Настройки", for: .normal)
        button.configuration?.baseBackgroundColor = .black
        button.configuration?.baseForegroundColor = .white
        button.configuration?.contentInsets = .init(top: 12, leading: 20, bottom: 12, trailing: 20)
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        let action = UIAction(title: "Настройки") { [weak self] _ in
            let thirdTVC = SettingViewController()
            thirdTVC.modalPresentationStyle = .formSheet
            self?.present(thirdTVC, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
    }
}
