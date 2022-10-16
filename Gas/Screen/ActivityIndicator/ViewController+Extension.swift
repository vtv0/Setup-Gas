//
//  File.swift
//  Gas
//
//  Created by Vuong The Vu on 14/10/2022.
//

import UIKit

extension UIViewController  {
    
    func showActivity() {
       let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
       // disableUserInteraction()
        
       let greyView = UIView()
        greyView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        greyView.backgroundColor = UIColor.black
        greyView.alpha = 0.5
        self.view.addSubview(greyView)
    }
    
    func hiddenActivity() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
         //activityIndicator.center = self.view.center
        // activityIndicator.hidesWhenStopped = true
         
         view.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
    }
}

