import Foundation
import UIKit

final class CharacteristicsCell: UICollectionViewCell {
    static var identifier = "CharacteristicsCellKey"
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private let unitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: CharacteristicsCellViewModel) {
        valueLabel.text = String(viewModel.value)
        unitsLabel.text = viewModel.title + ", " + viewModel.units
    }
}

private extension CharacteristicsCell {
    func createConstraints() {
        contentView.addSubview(valueLabel)
        contentView.addSubview(unitsLabel)
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.07)
        contentView.layer.cornerRadius = 25
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            unitsLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            unitsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            unitsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            unitsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25)
        ])
    }
}
