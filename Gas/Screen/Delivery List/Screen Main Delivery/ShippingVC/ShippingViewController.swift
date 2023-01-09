//
//  ShippingViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 09/01/2023.
//

import UIKit

class ShippingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let arrStatus = ["Return failed to deliver", "Unable to deliver", "Complete"]
    
    var selectedRows = [IndexPath]()
    
    @IBAction func btnExit(_ sender: Any) {
        let mainScreen = storyboard?.instantiateViewController(withIdentifier: "DeliveryListController") as! DeliveryListController
        self.navigationController?.pushViewController(mainScreen, animated: true)
     }

    
    @IBOutlet weak var viewRadioButton: UIView!
    @IBOutlet weak var myTableView: UITableView!
    
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
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        self.myTableView.rowHeight = myTableView.frame.height / 3
        myTableView.isScrollEnabled = false
   
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStatus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = myTableView.dequeueReusableCell(withIdentifier: "RadioTableViewCell") as! RadioTableViewCell
        cell.lblStatus.text = arrStatus[indexPath.row]
//        cell.btnRadioButton.setImage(UIImage(named: "ic_radio_checked"), for: .normal)
        
        if selectedRows.contains(indexPath) {
            cell.btnRadioButton.setImage(UIImage(named: "ic_radio_checked"), for: .normal)
        } else {
            cell.btnRadioButton.setImage(UIImage(named: "ic_radio_not_checked"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = myTableView.cellForRow(at: indexPath) as? RadioTableViewCell else { return }
        if self.selectedRows.contains(indexPath) {
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
            cell.btnRadioButton.setImage(UIImage(named: "ic_radio_not_checked"), for: .normal)
            print(selectedRows)
        } else {
            self.selectedRows.append(indexPath)
            cell.btnRadioButton.setImage(UIImage(named: "ic_radio_checked"), for: .normal)
            print(selectedRows)
        }
    }

   
}

