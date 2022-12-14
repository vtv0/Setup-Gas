//
//  ContentReplanController.swift
//  Gas
//
//  Created by Vuong The Vu on 28/09/2022.
//

import UIKit

protocol InfoACellDelegateProtocol: AnyObject {
    func passData(index: Int, assetID: String)
    func unselected(index: Int, assetID: String)
}

class ContentReplanController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegateContenReplant: InfoACellDelegateProtocol?
    var selectedRows1: [Int] = []
    var selectedRows: [IndexPath] = []
    
    var dataDidFilter: [Location] = []
    
    var arrKyokyusetsubi_code: [String] = []
    var arrCustomer_name = [String]()
    var arrPlanned_date = [String]()
    var arrDateMMDD: [Date] = []
    var arrLocationOrder = [Int]()
    var arrStringDateMMDD = [String]()
    var arrAssetID: [String] = []
    
    var isCustomer: Location = Location(elem: LocationElement(locationOrder: 0), asset: GetAsset())
    var dataIsCustomer: [Location] = []
    var dataIsCustomerToObject: [LocationToObject] = []
    var arrAssetIDDidSelected = [String]()
    
    var selectedIdxDate = 0
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //self.view.bringSubviewToFront(myTableView)
        
        detailsCustomer()
    }
    
    func detailsCustomer() {
        
        arrLocationOrder.removeAll()
        arrKyokyusetsubi_code.removeAll()
        arrCustomer_name.removeAll()
        arrPlanned_date.removeAll()
        arrAssetID.removeAll()
        
        for iCustomer in dataDidFilter where iCustomer.type == .customer {
            dataIsCustomer.append(iCustomer)
            
            if let locationOrder = iCustomer.elem?.locationOrder,
               let kyokyusetsubiCode = iCustomer.asset?.properties?.values.kyokyusetsubi_code,
               let customerName = iCustomer.asset?.properties?.values.customer_name,
               let plannedDate = iCustomer.elem?.metadata?.planned_date,
               let assetID = iCustomer.elem?.location?.assetID {
                
                arrLocationOrder.append(locationOrder)
                arrKyokyusetsubi_code.append(kyokyusetsubiCode)
                arrCustomer_name.append(customerName)
                arrPlanned_date.append(plannedDate)
                arrAssetID.append(assetID)
                
            }
        }
        self.convertArrDateMMDD()
    }
    
    func convertArrDateMMDD() {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd"
        for iday in arrPlanned_date {
            if let iday1 = dateFomatter.date(from: iday) {
                arrDateMMDD.append(iday1)
            }
        }
        self.convertDateToString()
    }
    
    
    func convertDateToString() {
        let dateFomater = DateFormatter()
        dateFomater.dateFormat = "MM/dd"
        
        for idate in arrDateMMDD {
            arrStringDateMMDD.append(dateFomater.string(from: idate))
        }
    }
    
    //    func deleteRows() {
    //        if let selectedRows = myTableView.indexPathsForSelectedRows {
    //            // 1
    //            var items = [String]()
    //            for indexPath in selectedRows  {
    //                items.append(arrCustomer_name[indexPath.row])
    //            }
    //
    //            // 2
    //            for item in items {
    //                if let index = arrCustomer_name.firstIndex(of: item) {
    //                    arrCustomer_name.remove(at: index)
    //                }
    //            }
    //            // 3
    //            myTableView.deleteRows(at: selectedRows, with: .automatic)
    //            myTableView.reloadData()
    //        }
    //    }
    
    
    // myTableView dataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "ContentReplanTableViewCell", for: indexPath) as! ContentReplanTableViewCell
        // ngày 1 exclude_firstday
        cell.lbl_locationOrder.text = "\((dataDidFilter[indexPath.row].elem?.locationOrder ?? 0) - 1)"
        cell.lbl_kyokyusetsubi_code.text = dataDidFilter[indexPath.row].asset?.properties?.values.kyokyusetsubi_code
        
        cell.lbl_locationOrder.layer.borderWidth = 1
        cell.lbl_locationOrder.layer.borderColor = UIColor.black.cgColor
        cell.lbl_locationOrder.textAlignment = .center
        cell.lbl_locationOrder.layer.cornerRadius = (cell.lbl_locationOrder.frame.size.width) / 2
        cell.lbl_locationOrder.layer.masksToBounds = true

        cell.lbl_customer_name.text = dataDidFilter[indexPath.row].asset?.properties?.values.customer_name
        
        cell.lbl_planned_date.text = arrStringDateMMDD[indexPath.row]
        
        
        
        // move_to_firstday = true -> to den cell
        // trong object co truong move_to_firstday = true
      
       if  dataIsCustomer[indexPath.row].elem?.location?.metadata?.display_data?.move_to_firstday == true {
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
                cell.contentView.backgroundColor = .darkGray
            } else {
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
                cell.contentView.backgroundColor = .systemBackground
            }

        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrKyokyusetsubi_code.count
    }
    
    
    // myTable view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = myTableView.cellForRow(at: indexPath) as? ContentReplanTableViewCell else { return }

        if selectedIdxDate == 0  {
            // neu la ngay dau tien thi chi dc exclude_firstday
            print("ngày đầu tiên đi học")
            
        } else {
            // chi dược move_to_firstday
            
            if self.selectedRows.contains(indexPath) {
                // uncheck
                self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
                
               
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
                delegateContenReplant?.unselected(index: indexPath.row, assetID: arrAssetID[indexPath.row])
                
            } else {
                // click cell add
                // move_to_firstday = true
                
                self.selectedRows.append(indexPath)
                
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
                
                
                // chuyen move_to_firstday = true
                // tao khi khong co properties: move_to_firstday
                
                for iCustomer in dataIsCustomer {
                    print(iCustomer.elem?.location?.metadata?.display_data)
                    if (iCustomer.elem?.location?.metadata?.display_data?.move_to_firstday == false || iCustomer.elem?.location?.metadata?.display_data?.move_to_firstday == nil) {

                        iCustomer.elem?.location?.metadata?.display_data?.move_to_firstday = true
                     
                        
                    }
                }
                
                delegateContenReplant?.passData(index: indexPath.row, assetID: arrAssetID[indexPath.row])
            }
        }
    }
    
}
