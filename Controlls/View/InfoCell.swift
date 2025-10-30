import Foundation
import UIKit

final class InfoCell: UICollectionViewCell {
    static var identifier = "InfoCellKey"
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    private let leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: InfoCellViewModels) {
        rightLabel.text = viewModel.value
        leftLabel.text = viewModel.title
    }
}

private extension InfoCell {
    func makeConstraints() {
        contentView.addSubview(container)
        container.addSubview(rightLabel)
        container.addSubview(leftLabel)
        NSLayoutConstraint.activate([
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),

            leftLabel.topAnchor.constraint(equalTo: container.topAnchor),
            leftLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            leftLabel.trailingAnchor.constraint(equalTo: rightLabel.leadingAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),

            rightLabel.topAnchor.constraint(equalTo: container.topAnchor),
            rightLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
        ])
    }
}
