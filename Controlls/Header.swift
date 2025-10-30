import Foundation
import UIKit

final class Header: UICollectionReusableView {
    static var identifier = "HeaderKey"
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ header: String) {
        label.text = header
    }
}

private extension Header {
    func makeConstraints() {
        self.addSubview(mainView)
        mainView.addSubview(label)
        NSLayoutConstraint.activate([
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 40),

            label.topAnchor.constraint(equalTo: mainView.topAnchor),
            label.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 5)
        ])
    }
}
