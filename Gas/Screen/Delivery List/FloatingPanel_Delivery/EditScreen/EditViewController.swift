//
//  EditViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 03/10/2022.
//

import UIKit

class EditViewController: UIViewController {
    
    var currentIndex: Int = 0
    var pageController: UIPageViewController!
    
    @IBOutlet var tabsView: TabsView!
    @IBAction func btnExit(_ sender: Any) {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn chắc chắn thoát Edit", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
            //             self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Screen"
        //        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        setupTabs()
        
        setupPageViewController()
    }
    
    func setupTabs() {
        // Add Tabs (Set 'icon'to nil if you don't want to have icons)
        tabsView.tabs = [
            Tab(icon: UIImage(named: ""), title: "General"),
            Tab(icon: UIImage(named: ""), title: "Parking"),
            Tab(icon: UIImage(named: ""), title: "Customer"),
            //            Tab(title: "ssss"),
            //            Tab(title: "aaa"),
            //            Tab(title: "eeee"),
            //            Tab(title: "rrr"),
            //            Tab(title: "yyyefcg56v7kb78oln8"),
            
        ]
        
        // Set TabMode to '.fixed' for stretched tabs in full width of screen or '.scrollable' for scrolling to see all tabs
        tabsView.tabMode = .fixed
        
        // TabView Customization
        tabsView.titleColor = .blue
        tabsView.iconColor = .blue
        tabsView.indicatorColor = .black
        tabsView.titleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        // tabsView.collectionView.backgroundColor = .cyan
        
        // Set TabsView Delegate
        tabsView.delegate2 = self
        
        // Set the selected Tab when the app starts
        tabsView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
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
        pageController.setViewControllers([showViewController(0)!], direction: .forward, animated: true, completion: nil)
        
        // PageViewController Constraints
        self.pageController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pageController.view.topAnchor.constraint(equalTo: self.tabsView.bottomAnchor),
            self.pageController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.pageController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.pageController.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Refresh CollectionView Layout when you rotate the device
        tabsView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // Show ViewController for the current position
    func showViewController(_ index: Int) -> UIViewController? {
        if (self.tabsView.tabs.count == 0) || (index >= self.tabsView.tabs.count) {
            return nil
        }
        
        currentIndex = index
        
        if index == 1 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "ParkingLocationController") as? ParkingLocationController
            contentVC?.pageIndex = index
            
            return contentVC
        } else if index == 2 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "CustomerLocationController") as? CustomerLocationController
            
            contentVC?.pageIndex = index
            return contentVC
        } else {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "GeneralInfoController") as? GeneralInfoController
            
            contentVC?.pageIndex = index
            return contentVC
        }
    }
}

extension EditViewController: TabsDelegate {
    
    func tabsViewDidSelectItemAt(position: Int) {
        // Check if the selected tab cell position is the same with the current position in pageController, if not, then go forward or backward
        if position != currentIndex {
            if position > currentIndex {
                self.pageController.setViewControllers([showViewController(position)!], direction: .forward, animated: true, completion: nil)
            } else {
                self.pageController.setViewControllers([showViewController(position)!], direction: .reverse, animated: true, completion: nil)
            }
            tabsView.collectionView.scrollToItem(at: IndexPath(item: position, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

extension EditViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // return ViewController when go forward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        // Don't do anything when viewpager reach the number of tabs
        if index == tabsView.tabs.count {
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if completed {
                guard let vc = pageViewController.viewControllers?.first else { return }
                let index: Int
                index = getVCPageIndex(vc)
                tabsView.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredVertically)
                // Animate the tab in the TabsView to be centered when you are scrolling using .scrollable
                tabsView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    // Return the current position that is saved in the UIViewControllers we have in the UIPageViewController
    func getVCPageIndex(_ viewController: UIViewController?) -> Int {
        switch viewController {
        case is ParkingLocationController:
            let vc = viewController as! ParkingLocationController
            
            return vc.pageIndex
        case is CustomerLocationController:
            let vc = viewController as! CustomerLocationController
            return vc.pageIndex
        default:
            let vc = viewController as! GeneralInfoController
            return vc.pageIndex
        }
    }
}
