//
//  File.swift
//  Gas
//
//  Created by Vuong The Vu on 14/10/2022.
//

import UIKit



extension UIViewController  {
    
    func showActivity() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        // disableUserInteraction()
        
        let greyView = UIView()
        greyView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        greyView.backgroundColor = UIColor.black
        greyView.alpha = 0.5
        self.view.addSubview(greyView)
    }
    
    func hideActivity() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
        activityIndicator.center = self.view.center
         activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        //self.activ
        
        //self.view.addSubview(activityIndicator)
      //  activityIndicator.hidesWhenStopped = true
        activityIndicator.removeFromSuperview()
       
    }
}

