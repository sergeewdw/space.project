import UIKit

final class ButtonCell: UICollectionViewCell {
    static var identifier = "ButtonCellKey"
    var onStartingsTap: (() -> Void)?
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Просмотр запусков", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
    }()

    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(white: 1, alpha: 0.07)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ButtonCell {
    func makeConstraints() {
        contentView.addSubview(mainView)
        mainView.addSubview(startButton)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            startButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc
    func startTapped() {
        onStartingsTap?()
    }
}
