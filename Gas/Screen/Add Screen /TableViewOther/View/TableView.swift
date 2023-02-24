//
//  TableView.swift
//  Gas
//
//  Created by Vuong The Vu on 16/02/2023.
//

import UIKit


class TableView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationsIsCustomer: [Location] = []
    var arrImages = [UIImage]()
    var md5data : [String] = []
    
    var arrUrls: [[String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 400
        
        let tableViewCell = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(tableViewCell, forCellReuseIdentifier: "tableViewCell")
        tableView.allowsSelection = false
    }
    
   
    
    
    
}

extension TableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsIsCustomer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellTable = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? TableViewCell {
            
            cellTable.lblCustomerID.text = locationsIsCustomer[indexPath.row].elem?.location?.comment ?? ""
            cellTable.lblDeliveryDestination.text = locationsIsCustomer[indexPath.row].asset?.properties?.values.customer_name
            cellTable.lblDeliveryAddress.text = locationsIsCustomer[indexPath.row].asset?.properties?.values.address
            if let minutes = locationsIsCustomer[indexPath.row].elem?.arrivalTime?.minutes,
               let hours = locationsIsCustomer[indexPath.row].elem?.arrivalTime?.hours {
                if minutes < 10 {
                    cellTable.lblEstimateTime?.text = "Estimate Time : \(hours):0\(minutes)"
                } else {
                    cellTable.lblEstimateTime?.text = "Estimate Time : \(hours):\(minutes)"
                }
            }
            
            cellTable.urls = locationsIsCustomer[indexPath.row].urls()
            if locationsIsCustomer[indexPath.row].urls().isEmpty {
                cellTable.stackViewContainer.isHidden = true
            } else {
                cellTable.stackViewContainer.isHidden = false
            }
            
            // tao ra [ [String] ]:
            let urlsImage = locationsIsCustomer[indexPath.row].urls()
            if !urlsImage.isEmpty {  // co URL image
                cellTable.urls = locationsIsCustomer[indexPath.row].urls()
                cellTable.loadImage(urls: locationsIsCustomer[indexPath.row].urls())
                
            } else {
                cellTable.urls = []
            }
            
            if locationsIsCustomer[indexPath.row].elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .waiting {
                cellTable.backgroundColor = UIColor(named: "blueMarker")
            } else if locationsIsCustomer[indexPath.row].elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .inprogress {
                cellTable.backgroundColor = UIColor(named: "yellowMarker")
            } else if locationsIsCustomer[indexPath.row].elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .failed || locationsIsCustomer[indexPath.row].elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .completed {
                cellTable.backgroundColor = UIColor(named: "grayMarker")
            } else {
                cellTable.backgroundColor = .white
            }
            
            return cellTable
        }
        return UITableViewCell()
    }
    
    
    
    
}

extension TableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


