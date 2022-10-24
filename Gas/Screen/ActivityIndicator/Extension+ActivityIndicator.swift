//
//  Extension+ActivityIndicator.swift
//  Gas
//
//  Created by vu the vuong on 23/10/2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showActivity() {
        
        let greyView = UIView()
        greyView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        greyView.backgroundColor = UIColor.black
        greyView.alpha = 0.5
        greyView.tag = 999
        self.view.addSubview(greyView)
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.tag = 100 // 100 for example
        // before adding it, you need to check if it is already has been added:
        for subview in view.subviews {
            if subview.tag == 100 {
                print("already added")
                return
            }
        }
        view.addSubview(activityIndicator)
        
    }
    
    func hideActivity() {
        let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        
        // I think you forgot to remove it?
        activityIndicator?.removeFromSuperview()
        activityIndicator?.removeFromSuperview()
        
        let deleteView =  view.viewWithTag(999)
        deleteView?.removeFromSuperview()
    }
}
