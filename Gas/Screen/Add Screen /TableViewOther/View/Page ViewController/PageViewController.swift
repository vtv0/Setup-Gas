//
//  PageViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 28/02/2023.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var listViewControllers: [UIViewController]?
    
    var urlsImage: [String] = []
    var image: UIImage?
    var indexImage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(urlsImage)
        print(indexImage)
        
        dataSource = self
        
    }
    
    func viewControllerAtIndex(index: Int) -> FullScreenImageVC {
            let storyboard = UIStoryboard.init(name: "FullScreenImage", bundle: nil)
            
            if let childVC = storyboard.instantiateViewController(withIdentifier: "FullScreenImageVC") as? FullScreenImageVC {
                childVC.index = index
                return childVC
            }
            
            return FullScreenImageVC()
        }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let view = viewController as? FullScreenImageVC {
            var index = view.index
            if index == 0 {
                return nil
            }
            index -= 1
            
            return self.viewControllerAtIndex(index: index)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let view = viewController as? FullScreenImageVC {
            var index = view.index
            index += 1
            if index == urlsImage.count {
                return nil
            }
            return self.viewControllerAtIndex(index: index)
        }
        
        
        return nil
    }
    
    
    
    
}
