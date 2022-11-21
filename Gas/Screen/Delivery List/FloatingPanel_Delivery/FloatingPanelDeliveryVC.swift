//
//  FloatingPanelDeliveryVC.swift
//  Gas
//
//  Created by Vuong The Vu on 04/10/2022.
//

import UIKit

protocol TabsDelegate {
    func tabsViewDidSelectItemAt(position: Int)
}

class FloatingPanelDeliveryVC: UIViewController {
    
    var currentIndex: Int = 0
    var pageController: UIPageViewController!
    var customer_LocationType = [String]()
    var customer_id: [String] = []
    var dataDidFilter: [Location] = []
    var scrollView: UIScrollView!
    
    var myOperation: DeliveryListController?
    
    @IBOutlet weak var detailsTabsView: TabsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FloatingPanel PageVC"
        // navigationController?.navigationBar.backgroundColor = .systemBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        setupTabs()
        
        setupPageViewController()
    }
    
    func setupTabs() {
        for item in customer_id {
            let tab = Tab(icon: UIImage(named: ""), title: item)
            if (detailsTabsView != nil) {
                detailsTabsView.tabs.append(tab)
            }
        }
        // Set TabMode to '.fixed' for stretched tabs in full width of screen or '.scrollable' for scrolling to see all tabs
        detailsTabsView.tabMode = .fixed
        
        // TabView Customization
        detailsTabsView.titleColor = .blue
        detailsTabsView.iconColor = .blue
        detailsTabsView.indicatorColor = .black
        detailsTabsView.titleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        // detailsTabsView.collectionView.backgroundColor = .cyan
        
        // Set detailsTabsView Delegate
        detailsTabsView.delegate = self
        
        // Set the selected Tab when the app starts
        detailsTabsView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
    }
    
    func setupPageViewController() {
        // PageViewController
        self.pageController = storyboard?.instantiateViewController(withIdentifier: "TabsPageViewController") as! TabsPageViewController
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        
        // Set PageViewController Delegate & DataSource
        pageController.delegate = self
        pageController.dataSource = self
        
        
        // Set the selected ViewController in the PageViewController when the app starts
        pageController.setViewControllers([showViewController(0)!], direction: .forward, animated: false, completion: nil)
        
        // PageViewController Constraints
        self.pageController.view.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([
            self.pageController.view.topAnchor.constraint(equalTo: self.detailsTabsView.bottomAnchor),
            self.pageController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.pageController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.pageController.didMove(toParent: self)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Refresh CollectionView Layout when you rotate the device
        detailsTabsView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func showViewController(_ index: Int) -> UIViewController? {
        if (self.detailsTabsView.tabs.count == 0) || (index >= self.detailsTabsView.tabs.count) {
            return nil
        }
        currentIndex = index
        let contentVC = storyboard?.instantiateViewController(withIdentifier: "PageDetailVC") as! PageDetailVC
        contentVC.pageIndex = index
        contentVC.dataInfoOneCustomer = dataDidFilter[index]
      
        contentVC.customer_id = customer_id[index]
        contentVC.scrollView = scrollView
        return contentVC
    }
}


extension FloatingPanelDeliveryVC: TabsDelegate {
    
    func tabsViewDidSelectItemAt(position: Int) {
        // Check if the selected tab cell position is the same with the current position in pageController, if not, then go forward or backward
        
        if position != currentIndex {
            if position > currentIndex {
                self.pageController.setViewControllers([showViewController(position)!], direction: .forward, animated: true, completion: nil)
            } else {
                self.pageController.setViewControllers([showViewController(position)!], direction: .reverse, animated: true, completion: nil)
            }
            detailsTabsView.collectionView.scrollToItem(at: IndexPath(item: position, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}


extension FloatingPanelDeliveryVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource, ShowResult {
    
    func loadMyOperation() {
        if myOperation == nil {
            myOperation = DeliveryListController()
        }
    }
    func show(value: Int) {
        print("value: \(value)")
    }
    
    //delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if completed {
                guard let vc = pageViewController.viewControllers?.first else { return }
                let index: Int
                index = getVCPageIndex(vc)
                detailsTabsView.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredVertically)
                // Animate the tab in the detailsTabsView to be centered when you are scrolling using .scrollable
                
                print("chuyen tab trong floatingPanel")
                loadMyOperation()
                myOperation?.delegateCustom = self
                myOperation?.sum(fNumber: 9, sNumber: 20)
                
                
                detailsTabsView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    // Return the current position that is saved in the UIViewControllers we have in the UIPageViewController
    func getVCPageIndex(_ viewController: UIViewController?) -> Int {
        let vc = viewController as! PageDetailVC
        return vc.pageIndex
    }
    
    
    // dataSource
    // return ViewController when go forward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        // Don't do anything when viewpager reach the number of tabs
        if index == detailsTabsView.tabs.count {
            return nil
        } else {
            index += 1
            return self.showViewController(index)
        }
    }
    
    // return ViewController when go backward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        if index == 0 {
            return nil
        } else {
            index -= 1
            
            return self.showViewController(index)
        }
    }
    
    
    
}
