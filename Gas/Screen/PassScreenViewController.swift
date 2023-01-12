//
//  PassScreenViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 21/10/2022.
//

import UIKit

class PassScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.value(forKey: "accessToken") != nil) {
            print("da co token")
            let vc = storyboard?.instantiateViewController(withIdentifier: "DeliveryListController") as! DeliveryListController
            self.navigationController?.pushViewController(vc, animated: false)
            
        } else {
            print("chua co token")
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
}
