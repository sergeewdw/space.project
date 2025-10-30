import Foundation
import UIKit

final class ImageCell: UICollectionViewCell {
    static var identifier = "ImageCellKey"
    var onSettingsTap: (() -> Void)?
    private let rocketView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.layer.cornerRadius = 30
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let rocketImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameRocketLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var settingsButton: UIButton = {
        let imageView = UIButton(type: .system)
        imageView.setImage(UIImage(systemName: "gearshape"), for: .normal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.contentHorizontalAlignment = .fill
        imageView.contentVerticalAlignment = .fill
        imageView.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstrains()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ rocket: RocketInfo) {
        nameRocketLabel.text = rocket.name
        if let url = URL(string: rocket.flickrImages?.randomElement() ?? "") {
            self.rocketImageView.kf.setImage(with: url)
        }
    }
}

private extension ImageCell {
    func makeConstrains() {
        contentView.addSubview(rocketImageView)
        contentView.addSubview(rocketView)
        rocketView.addSubview(settingsButton)
        rocketView.addSubview(nameRocketLabel)
        NSLayoutConstraint.activate([
            rocketImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rocketImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rocketImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rocketImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            rocketView.leadingAnchor.constraint(equalTo: rocketImageView.leadingAnchor),
            rocketView.trailingAnchor.constraint(equalTo: rocketImageView.trailingAnchor),
            rocketView.bottomAnchor.constraint(equalTo: rocketImageView.bottomAnchor),
            rocketView.heightAnchor.constraint(equalToConstant: 100),

            settingsButton.centerYAnchor.constraint(equalTo: rocketView.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: rocketView.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            settingsButton.widthAnchor.constraint(equalToConstant: 35),
            settingsButton.heightAnchor.constraint(equalToConstant: 35),

            nameRocketLabel.centerYAnchor.constraint(equalTo: rocketView.centerYAnchor),
            nameRocketLabel.leadingAnchor.constraint(equalTo: rocketView.safeAreaLayoutGuide.leadingAnchor, constant: 40)
        ])
    }

    @objc
    func settingsTapped() {
        onSettingsTap?()
    }
}
