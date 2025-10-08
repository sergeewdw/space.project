import UIKit

final class PageViewController: UIPageViewController {
    private var currentPage = 0
    private let networkService = NetworkService()
    private var vcArray: [UIViewController] = {
        let firstVC = FirstViewController()
        let greenVC = UIViewController()
        greenVC.view.backgroundColor = .green
        let thirdTVC = ThirdViewController()
        return [firstVC, greenVC, thirdTVC]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let first = vcArray.first {
            self.setViewControllers([first], direction: .forward, animated: true)
        }
        networkService.getRockets { result in
            switch result {
            case .success(let rocket):
                print("\(rocket.count) rockets.")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        networkService.getLaunches(by:"5e9d0d95eda69955f709d1eb") { result in
            switch result {
            case .success(let launches):
                print("\(launches) launches.")
            case .failure(let error):
                print(error.localizedDescription)
            }
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
