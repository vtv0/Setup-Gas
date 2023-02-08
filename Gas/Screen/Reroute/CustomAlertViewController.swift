//
//  CustomAlertViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 10/10/2022.
//

import UIKit

class CustomAlertViewController: UIViewController {

    @IBAction func btnCancelCustom(_ sender: Any) {
        dismiss(animated: false)
        
    }
    @IBAction func btnRerouteCustom(_ sender: Any) {
        dismiss(animated: false)
        
    }
    
    @IBOutlet weak var viewAlert: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlert.layer.cornerRadius = 12
        viewAlert.layer.masksToBounds = true
       
    }
}
