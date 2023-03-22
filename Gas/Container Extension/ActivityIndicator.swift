//
//  ActivityIndicator.swift
//  Gas
//
//  Created by vu the vuong on 23/10/2022.
//

import UIKit

class ActivityIndicator: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func showActivityIndicatory(uiView: UIView) {
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.style = UIActivityIndicatorView.Style.whiteLarge
        uiView.addSubview(actInd)
        activityIndicator.startAnimating()
    }
    
}
