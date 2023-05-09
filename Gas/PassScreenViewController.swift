//
//  PassScreenViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 21/10/2022.
//

import UIKit
import SwiftUI

class PassScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if (UserDefaults.standard.value(forKey: "accessToken") != nil) {
//            print("da co token")
//            let vc = storyboard?.instantiateViewController(withIdentifier: "DeliveryListController") as! DeliveryListController
////            let vc = storyboard?.instantiateViewController(withIdentifier: "ScreenExpandVC") as! ScreenExpandVC
//            self.navigationController?.pushViewController(vc, animated: false)
//
//        } else {
//            print("chua co token")
//            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
//            self.navigationController?.pushViewController(vc, animated: false)
//        }
        
        let controller = UIHostingController(rootView: LoginSwiftUI())
        controller.view?.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)

        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            controller.view.heightAnchor.constraint(equalToConstant: self.view.frame.height)


        ])
        
    }
    
}
