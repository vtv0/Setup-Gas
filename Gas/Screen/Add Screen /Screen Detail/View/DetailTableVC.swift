//
//  DetailTableVC.swift
//  Gas
//
//  Created by Vuong The Vu on 14/02/2023.
//

import UIKit

class DetailTableVC: UIViewController {
    
    @IBOutlet weak var myTableViewDetail: UITableView!
    
    var detailTable_Presenter = Presenter_DetailTable()
    var locationsIsCustomer: [Location] = []  // chua duong dan Image
    var urlImages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableViewDetail.dataSource = self
        myTableViewDetail.dataSource = self
        myTableViewDetail.rowHeight = 230
        
        detailTable_Presenter.getImage(locationsIsCustomer: locationsIsCustomer)
        detailTable_Presenter.statusDelivery(locationsIsCustomer: locationsIsCustomer)
    }
}


extension DetailTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsIsCustomer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDetail = myTableViewDetail.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell

        cellDetail.lblCustomerCode.text = "\(locationsIsCustomer[indexPath.row].elem?.location?.comment ?? "" )"
        cellDetail.lblReceivingAddress.text = "\(locationsIsCustomer[indexPath.row].asset?.properties?.values.customer_name ?? "" )"
        cellDetail.lblDeliveryAddress.text = "\(locationsIsCustomer[indexPath.row].asset?.properties?.values.address ?? "" )"
        
        
        if let minutes = locationsIsCustomer[indexPath.row].elem?.arrivalTime?.minutes,
           let hours = locationsIsCustomer[indexPath.row].elem?.arrivalTime?.hours {
            if minutes < 10 {
                cellDetail.lblEstimateTime.text = "Estimate Time : \(hours):0\(minutes)"
            } else {
                cellDetail.lblEstimateTime.text = "Estimate Time : \(hours):\(minutes)"
            }
        }
        
        // color of cell
        if ((locationsIsCustomer[indexPath.row].asset?.properties?.values.display_data) != nil) {
            cellDetail.backgroundColor = UIColor(named: "blueMarker")
        }
        
        // neu khong co duong dan -> an collection Image di
        if urlImages.isEmpty {
            cellDetail.colectionViewImage.isHidden = true  // dung
            
        } else {
            // hien thi anh
        }
        
        
        return cellDetail
    }
}

