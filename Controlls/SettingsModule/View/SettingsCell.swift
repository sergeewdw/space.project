import UIKit

final class SettingsCell: UITableViewCell {
    static var identifier = "SettingsCellIdentifier"
    var didChangeIndex: ((Int) -> Void)?

    private lazy var unitsSelector: UISegmentedControl = {
        let control = UISegmentedControl()
        control.backgroundColor = UIColor(white: 1, alpha: 0.005)
        control.selectedSegmentTintColor = .white
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray2   // серый для невыбранных
        ]

        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black         // белый для выбранного
        ]
        control.setTitleTextAttributes(normalAttrs, for: .normal)
        control.setTitleTextAttributes(selectedAttrs, for: .selected)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        configureUI()
        createConstarints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureElements(viewModel: SettingsCellViewModel) {
        label.text = viewModel.type.rawValue
        unitsSelector.insertSegment(withTitle: viewModel.type.metricDimension.rawValue, at: 0, animated: false)
        unitsSelector.insertSegment(withTitle: viewModel.type.imperialDimension.rawValue, at: 1, animated: false)
        unitsSelector.selectedSegmentIndex = viewModel.settingsUnits.rawValue
    }
}

// MARK: Configure UI

private extension SettingsCell {
    func setupViews() {
        contentView.addSubview(label)
        contentView.addSubview(unitsSelector)
    }

    func createConstarints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            unitsSelector.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            unitsSelector.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            unitsSelector.widthAnchor.constraint(equalToConstant: 110),
            unitsSelector.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    func configureUI() {
        selectionStyle = .none
        backgroundColor = .black
        textLabel?.textColor = .white
    }

    @objc
    func segmentChanged() {
        didChangeIndex?(unitsSelector.selectedSegmentIndex)
    }
}
