import UIKit

final class LaunchesCell: UICollectionViewCell {
    static let identifier = "LaunchesCellIdentifier"

    private let viewLabel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.07)
        view.layer.cornerRadius = 25
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let rocketNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let rocketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rocketImage")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let flightDisplayView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "d MMMM, yyyy"
        return formatter
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with rockets: LaunchCellVIewModels) {
        rocketNameLabel.text = rockets.name
        dateLabel.text = dateFormatter.string(from: rockets.dateUtc)
        setFlightStatus(success: rockets.success)
    }
}

// MARK: - Private

private extension LaunchesCell {
    func setupViews() {
        contentView.addSubview(viewLabel)
        viewLabel.addSubview(rocketNameLabel)
        viewLabel.addSubview(dateLabel)
        viewLabel.addSubview(iconContainer)
        iconContainer.addSubview(rocketImageView)
        iconContainer.addSubview(flightDisplayView)
    }

    func makeConstraints() {
        NSLayoutConstraint.activate([
            viewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            viewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            viewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            viewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),

            rocketNameLabel.topAnchor.constraint(equalTo: viewLabel.topAnchor, constant: 25),
            rocketNameLabel.leadingAnchor.constraint(equalTo: viewLabel.leadingAnchor, constant: 22),
            rocketNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconContainer.leadingAnchor, constant: -12),

            dateLabel.topAnchor.constraint(equalTo: rocketNameLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: rocketNameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconContainer.leadingAnchor, constant: -12),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: viewLabel.bottomAnchor, constant: -15),

            iconContainer.trailingAnchor.constraint(equalTo: viewLabel.trailingAnchor, constant: -40),
            iconContainer.centerYAnchor.constraint(equalTo: viewLabel.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 80),
            iconContainer.heightAnchor.constraint(equalToConstant: 80),

            rocketImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor, constant: 20),
            rocketImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            rocketImageView.widthAnchor.constraint(equalToConstant: 60),
            rocketImageView.heightAnchor.constraint(equalToConstant: 60),

            flightDisplayView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor),
            flightDisplayView.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: -23),
            flightDisplayView.widthAnchor.constraint(equalToConstant: 15),
            flightDisplayView.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

    func setFlightStatus(success: Bool) {
        let assetName = success ? "checkMark" : "redCross"
        flightDisplayView.image = UIImage(named: assetName)
    }
}
