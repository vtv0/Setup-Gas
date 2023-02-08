//
//  RerouteViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 10/10/2022.
//

import UIKit

class RerouteViewController: UIViewController {
    
    
    @IBAction func btnReroute(_ sender: Any) {
        print("click Popup")
//        // create the alert
//                let alert = UIAlertController(title: "UIAlertController", message: "sdfsdfsdfsfe", preferredStyle: UIAlertController.Style.alert)
//
//                // add the actions (buttons)
//                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
//                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//
//                // show the alert
//                self.present(alert, animated: true, completion: nil)
//            
        
    }
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBAction func btnCancel(_ sender: Any) {
        let alert  = UIAlertController(title: "Thông báo", message: "Bạn có muốn thoát màn hình Reroute", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
            let screenOther = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryListController") as! DeliveryListController
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false , completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reroute"
        
        txtView.isEditable = false
        
//        self.navigationController?.navigationBar.backgroundColor = .systemBlue
//        self.navigationItem.rightBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    
    
}
