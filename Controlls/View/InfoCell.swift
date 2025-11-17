import Foundation
import UIKit

final class InfoCell: UICollectionViewCell {
    static var identifier = "InfoCellKey"
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

    func configure(title: String, attributedValue: NSAttributedString) {
        leftLabel.text = title
        rightLabel.attributedText = attributedValue
    }
}

private extension InfoCell {
    func makeConstraints() {
        contentView.addSubview(rightLabel)
        contentView.addSubview(leftLabel)
        NSLayoutConstraint.activate([
            leftLabel.topAnchor.constraint(equalTo: self.topAnchor),
            leftLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftLabel.trailingAnchor.constraint(equalTo: rightLabel.leadingAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),

            rightLabel.topAnchor.constraint(equalTo: self.topAnchor),
            rightLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}
