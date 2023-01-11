//
//  FloatingPanelDeliveryVC.swift
//  Gas
//
//  Created by Vuong The Vu on 04/10/2022.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit
import FloatingPanel
import Contacts
import AlamofireImage

protocol TabsDelegate: AnyObject {
    func tabsViewDidSelectItemAt(position: Int)
}

protocol ShowIndexPageDelegateProtocol: AnyObject {
    func passIndexPVC(currentIndexPageVC: Int)
}

protocol PassScrollView: AnyObject {
    func passScrollView(scrollView: UIScrollView)
}

class FloatingPanelDeliveryVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    weak var delegate1: ShowIndexPageDelegateProtocol?
    
    weak var delegateScrollView: PassScrollView?
    
    var passIndexSelectedMarker = 0
    var currentIndex: Int = 0
    var pageController: UIPageViewController!
    var customer_LocationType = [String]()
    var dataDidFilter: [Location] = []
    var comment: [String] = []
    
    @IBOutlet weak var detailsTabsView: TabsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FloatingPanel PageVC"
        // navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        setupTabs()
        setupPageViewController()
        
        
    }
    
    func setupTabs() {
        for item in comment {
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
        detailsTabsView.titleFont = UIFont.systemFont(ofSize: 29, weight: .semibold)
        
        // Set detailsTabsView Delegate
        detailsTabsView.delegate2 = self
        
        // Set the selected Tab when the app starts
        detailsTabsView.collectionView.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: false, scrollPosition: .centeredVertically)
        
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
        pageController.setViewControllers([showViewController(currentIndex)!], direction: .forward, animated: true, completion: nil)
        
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
    
    
    // so luong man hinh Floating
    func showViewController(_ index: Int) -> UIViewController? {
        if (self.detailsTabsView.tabs.count == 0) || (index >= self.detailsTabsView.tabs.count) {
            return nil
        }
        
        currentIndex = index
        let contentVC = storyboard?.instantiateViewController(withIdentifier: "PageDetailVC") as! PageDetailVC
        contentVC.pageIndex = currentIndex
        contentVC.dataInfoOneCustomer = dataDidFilter[index]
        contentVC.comment = comment[index]
        
        
        return contentVC
    }
    
    
    // MARK: Delegate
    //delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if completed {
                
                guard let vc = pageViewController.viewControllers?.first as? PageDetailVC else { return }
                var index: Int
                
                index = getVCPageIndex(vc)
                delegate1?.passIndexPVC(currentIndexPageVC: index)
             
//                switch vc {
//                case is PageDetailVC:
//                   let scrollView = vc as! PageDetailVC
                    delegateScrollView?.passScrollView(scrollView: vc.viewContainerScrollview)
//                default: break
//                }

                // Animate the tab in the detailsTabsView to be centered when you are scrolling using .scrollable
                detailsTabsView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .bottom, animated: true)
                
            }
        }
    }
    
    // Return the current position that is saved in the UIViewControllers we have in the UIPageViewController
    func getVCPageIndex(_ viewController: UIViewController?) -> Int {
        switch viewController {
        case is PageDetailVC:
            let vc = viewController as! PageDetailVC
            
            return vc.pageIndex
        default:
            return currentIndex
        }
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


extension FloatingPanelDeliveryVC: TabsDelegate, GetIndexMarkerDelegateProtocol {
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
    
    func getIndexMarker(indexDidSelected: Int) {
        if indexDidSelected != currentIndex {
            if indexDidSelected > currentIndex {
                self.pageController.setViewControllers([showViewController(indexDidSelected)!], direction: .forward, animated: true, completion: nil)
            } else {
                self.pageController.setViewControllers([showViewController(indexDidSelected)!], direction: .reverse, animated: true, completion: nil)
            }
            detailsTabsView.collectionView.scrollToItem(at: IndexPath(item: indexDidSelected, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
}

