import UIKit

final class PageViewController: UIPageViewController {
    private var currentPage = 0
    private let networkService = NetworkService()
    private let storage = StorageProvider()
    private var viewArray: [UIViewController] = []

    init(
        transitionStyle: TransitionStyle = .scroll,
        navigationOrientation: NavigationOrientation = .horizontal
    ) {
        super.init(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        loadRockets()
    }
}

// MARK: DataSourse

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewArray.firstIndex(of: viewController) else { return nil }
        let newIndex = index - 1
        guard newIndex >= 0, newIndex < viewArray.count else { return nil }
        currentPage = index - 1
        return viewArray[newIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewArray.firstIndex(of: viewController) else { return nil }
        let newIndex = index + 1
        guard newIndex >= 0, newIndex < viewArray.count else { return nil }
        currentPage = index + 1
        return viewArray[newIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        viewArray.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentPage
    }
}

// MARK: Private

private extension PageViewController {
    func loadRockets() {
        networkService.getRockets { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let rockets):
                    self.viewArray = rockets.map { RocketViewController(rocket: $0, storage: self.storage) }
                    self.currentPage = 0
                    self.setViewControllers([self.viewArray[0]], direction: .forward, animated: false)

                case .failure(let error):
                    print("Rockets error:", error.localizedDescription)
                }
            }
        }
    }
}
