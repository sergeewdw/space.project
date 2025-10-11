import UIKit

final class SettingsCell: UITableViewCell {
    static var identifier = "SettingsCellIdentifier"
    private var didChangeIndex: ((Int) -> Void)?
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

    func configureElements(_ title: String, _ units: [String], _ index: Int, _ didChangeIndex: @escaping (Int) -> Void) {
        textLabel?.text = title
        for (i, unit) in units.enumerated() {
            unitsSelector.insertSegment(withTitle: unit, at: i, animated: false)
        }
        unitsSelector.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        unitsSelector.selectedSegmentIndex = index
        self.didChangeIndex = didChangeIndex
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
        didChangeIndex?(unitsSelector.selectedSegmentIndex)
    }
}
