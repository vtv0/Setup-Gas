//
//  ShippingViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 09/01/2023.
//

import UIKit

class ShippingViewController: UIViewController {
    let arrStatus = ["Return failed to deliver", "Unable to deliver", "Complete"]
    
    var selectedRows = [IndexPath]()
    
    @IBAction func btnExit(_ sender: Any) {
        let mainScreen = storyboard?.instantiateViewController(withIdentifier: "DeliveryListController") as! DeliveryListController
        self.navigationController?.pushViewController(mainScreen, animated: true)
     }

    @IBAction func btnSubmit(_ sender: Any) {
        print("CLICK SUBMIT")
    }
    
    @IBOutlet weak var viewInfomation: UIView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblEstimateTime: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Determine delivery content"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        lblStatus.layer.cornerRadius = 8
        lblStatus.layer.masksToBounds = true
        
//
//        self.myTableView.rowHeight = myTableView.frame.height / 3
//        myTableView.isScrollEnabled = false
   
    }
    
    
   

   
}

