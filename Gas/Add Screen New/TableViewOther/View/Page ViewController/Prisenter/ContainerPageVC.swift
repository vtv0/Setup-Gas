//
//  ContainerPageVC.swift
//  Gas
//
//  Created by Vuong The Vu on 02/03/2023.
//

import UIKit


class ContainerPageVC: UIViewController, UIPageViewControllerDelegate {
    
    var pageView: UIPageViewController!
    
    var urlsImage: [String] = []
    var currentIndex: Int = 0
    var indexImage: Int = 0
    var iurlImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingPageViewController()
    }
   
    
    func settingPageViewController() {
        let storyBoard = UIStoryboard(name: "PageViewController", bundle: nil)
        self.pageView = storyBoard.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController
        self.addChild(pageView)
        self.view.addSubview(self.pageView.view)
        pageView.dataSource = self
        pageView.delegate = self
        self.pageView.didMove(toParent: self)
        pageView.setViewControllers([numberScreenViewController(indexImage)!], direction: .forward, animated: false)
    }
    
    func numberScreenViewController(_ index: Int) -> UIViewController? {
        if (self.urlsImage.count == 0) || (index >= self.urlsImage.count) { return nil }
        currentIndex = index
        let storyboard = UIStoryboard(name: "FullScreenImage", bundle: nil)
        let screenZoomImage = storyboard.instantiateViewController(withIdentifier: "FullScreenImageVC") as! FullScreenImageVC
        screenZoomImage.pageIndex = currentIndex
        screenZoomImage.iurlImage = urlsImage[index]
        return screenZoomImage
    }
    
    func getVCPageIndex(_ viewController: UIViewController?) -> Int {
        var int: Int = 0
        if let vc = viewController as? FullScreenImageVC {
           int = vc.pageIndex
        }
         return int
    }
}

extension ContainerPageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        if index == 0 {
            return nil
        } else {
            index -= 1
            return self.numberScreenViewController(index)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        if index == urlsImage.count {
            return nil
        } else {
            index += 1
            return self.numberScreenViewController(index)
        }
    }
}
