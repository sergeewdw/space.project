import Foundation
import UIKit

final class CharacteristicsCell: UICollectionViewCell {
    static var identifier = "CharacteristicsCellKey"
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.07)
        view.layer.cornerRadius = 25
        return view
    }()

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
        label.font = .systemFont(ofSize: 15, weight: .medium)
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
        contentView.addSubview(mainView)
        mainView.addSubview(valueLabel)
        mainView.addSubview(unitsLabel)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            valueLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            valueLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),

            unitsLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            unitsLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            unitsLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8),
            unitsLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -25)
        ])
    }
}
