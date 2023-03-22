//
//  Extension+ActivityIndicator.swift
//  Gas
//
//  Created by vu the vuong on 23/10/2022.
//

import UIKit

extension UIViewController {
    
    func showActivity() {
        
        let greyView = UIView()
        greyView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        greyView.backgroundColor = UIColor.black
        greyView.alpha = 0.3
        greyView.tag = 999
//        window?.rootViewController?.view.addSubview(greyView)
        self.navigationController?.view.addSubview(greyView)
        greyView.layer.zPosition = 1000
        self.view.addSubview(greyView)
        //self.view.bringSubviewToFront(greyView)
//    self.view.layer.zPosition
        
//        UIApplication.shared.keyWindow?.addSubview(greyView)
//        UIApplication.shared.keyWindow?.bringSubviewToFront(greyView)
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor(red: 0.16, green: 0.17, blue: 0.21, alpha: 1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = view.center
        
        //activityIndicator.hidesWhenStopped = true
        
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.tag = 888 // 100 for example
        // before adding it, you need to check if it is already has been added:
        for subview in self.view.subviews {
            if subview.tag == 888 {
                //print("already added")
                return
            }
        }
        self.view.addSubview(activityIndicator)
        self.view.bringSubviewToFront(activityIndicator)
    }
    
    func hideActivity() {
        let activityIndicator = view.viewWithTag(888) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
       
        if (view.viewWithTag(999) != nil) {
            let deleteView =  view.viewWithTag(999)
            deleteView?.removeFromSuperview()
        }
        
        
    }
}
