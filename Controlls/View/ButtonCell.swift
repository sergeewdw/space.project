import UIKit

final class ButtonCell: UICollectionViewCell {
    static var identifier = "ButtonCellKey"
    weak var delegate: RocketScreenDelegate?
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Просмотр запусков", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
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
        contentView.addSubview(startButton)
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.07)
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc
    func startTapped() {
        delegate?.didTapStartLaunches()
    }
}
