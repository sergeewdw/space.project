import UIKit

final class SettingsCell: UITableViewCell {
    static var identifier = "SettingsCellIdentifier"
    private let unitsSelector: UISegmentedControl = {
        let control = UISegmentedControl()
        control.backgroundColor = .systemGray4
        control.selectedSegmentTintColor = .white
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.font = .systemFont(ofSize: 13)
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

    func configureElements() {
        textLabel?.text = "test text"
        unitsSelector.insertSegment(withTitle: "m", at: 0, animated: false)
        unitsSelector.insertSegment(withTitle: "ft", at: 1, animated: false)
        unitsSelector.selectedSegmentIndex = 0
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
            unitsSelector.widthAnchor.constraint(equalToConstant: 100),
            unitsSelector.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configureUI() {
        backgroundColor = .black
        textLabel?.textColor = .white
    }

    @objc func segmentChanged() {
    }
}
