import UIKit

class SettingTableViewCell: UITableViewCell {
    private let metric = Metric.allCases
    // MARK: Segmented Controll
    private func createSegmentedControl(for metricItem: Metric) -> UISegmentedControl {
        let currentUnits: [String]
        switch metricItem {
        case .height, .diameter:
            currentUnits = Unit.units
        case .mass, .usefulLoad:
            currentUnits = Unit.unitsMass
        }
        let segmentControl = UISegmentedControl(items: currentUnits)
        segmentControl.backgroundColor = .systemGray4
        segmentControl.selectedSegmentTintColor = .white
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentControl.accessibilityIdentifier = metricItem.rawValue
        let savedIndex = UserDefaults.standard.integer(forKey: metricItem.rawValue)
        segmentControl.selectedSegmentIndex = savedIndex
        return segmentControl
    }
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let metricName = sender.accessibilityIdentifier!
        let selectedIndex = sender.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: metricName)
        print("Сохранено")
    }
    // MARK: Configure Cell
       func configure(with metricItem: Metric) {
           textLabel?.text = metricItem.rawValue
           textLabel?.textColor = .white
           backgroundColor = .black
           selectionStyle = .none
           subviews.forEach { if $0 is UISegmentedControl { $0.removeFromSuperview() } }
           let segmentControl = createSegmentedControl(for: metricItem)
           addSubview(segmentControl)
           NSLayoutConstraint.activate([
               segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
               segmentControl.topAnchor.constraint(equalTo: topAnchor, constant: 8),
               segmentControl.widthAnchor.constraint(equalToConstant: 100),
               segmentControl.heightAnchor.constraint(equalToConstant: 30)
           ])
       }
}
