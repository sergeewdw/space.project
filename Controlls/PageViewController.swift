import UIKit

class PageViewController: UIPageViewController {
    private var currentPage = 0
    private var vcArray: [UIViewController] = {
        let redVC = UIViewController()
        redVC.view.backgroundColor = .red
        let greenVC = UIViewController()
        greenVC.view.backgroundColor = .green
        let yellowVC = UIViewController()
        yellowVC.view.backgroundColor = .yellow
        return [redVC, greenVC, yellowVC]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let first = vcArray.first {
            self.setViewControllers([first], direction: .forward, animated: true)
        }
    }
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: DataSourse

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcArray.firstIndex(of: viewController) else { return nil }
        let newIndex = index - 1
        guard newIndex >= 0, newIndex < vcArray.count else { return nil }
        currentPage = index - 1
        return vcArray[newIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcArray.firstIndex(of: viewController) else { return nil }
        let newIndex = index + 1
        guard newIndex >= 0, newIndex < vcArray.count else { return nil }
        currentPage = index + 1
        return vcArray[newIndex]
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        vcArray.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentPage
    }
}
