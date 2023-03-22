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
    var iurlImage: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let tableViewCell = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(tableViewCell, forCellReuseIdentifier: "tableViewCell")
        
        tableView.allowsSelection = false
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
}

extension TableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsIsCustomer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellTable = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? TableViewCell {
            cellTable.delegate = self
            
            
            
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
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
    //        cell.delegate = self
    //
    //    }
}

extension TableView: PassScreen {
    // func passScreen(image: UIImage?, iurlImage: String) {
    //        let storyboard = UIStoryboard(name: "FullScreenImage", bundle: nil)
    //        guard let passScreen = storyboard.instantiateViewController(withIdentifier: "FullScreenImageVC") as? FullScreenImageVC else { return }
    //        passScreen.image = image
    //passScreen.urlImage = iurlImage
    //        self.navigationController?.pushViewController(passScreen, animated: true)
    
    
    
    //   }
    
    func passListImages(urls: [String], indexUrl: Int, iurlImage: String) {
        print(urls)
        print(indexUrl)  // lay duoc ind cua anh trong mang
        let storyboard = UIStoryboard(name: "ContainerPageVC", bundle: nil)
        guard let passScreenPageView = storyboard.instantiateViewController(withIdentifier: "ContainerPageVC") as? ContainerPageVC else { return }
        passScreenPageView.urlsImage = urls
        passScreenPageView.indexImage = indexUrl
        passScreenPageView.iurlImage = iurlImage    
        self.navigationController?.pushViewController(passScreenPageView, animated: true)
        
    }
}


