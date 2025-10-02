
import UIKit

class PageViewController: UIPageViewController {
    
    
    
    lazy var vcArray: [UIViewController] = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let red = storyboard.instantiateViewController(withIdentifier: "RedView")
        let green = storyboard.instantiateViewController(withIdentifier: "GreenView")
        let yellow = storyboard.instantiateViewController(withIdentifier: "YellowView")
        
        
        return [red, green, yellow]
    }()
    
   private(set) var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        if let first = vcArray.first {
            self.setViewControllers([first], direction: .forward, animated: true)
        }
    }
}

//MARK: DataSourse

extension PageViewController: UIPageViewControllerDataSource {
    
    
    //Экран после текущего
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcArray.firstIndex(of: viewController) else { return nil }
        let newIndex = index - 1
        guard newIndex >= 0, newIndex < vcArray.count else { return nil }
        currentPage = index - 1
        return vcArray[newIndex]
    }
    
    //Экран перед текущим
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcArray.firstIndex(of: viewController) else { return nil }
        let newIndex = index + 1
        guard newIndex >= 0, newIndex < vcArray.count else { return nil }
        currentPage = index + 1
        return vcArray[newIndex]
    }
    
    //Количество страниц
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        vcArray.count
    }
    
    
    //Сообщает текущий индекс
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentPage
    }
    
}
