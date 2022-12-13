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
    
    var infomationDelivery = LocationOfReplan(elem: LocationElement.init(locationOrder: 0), asset: GetAsset())
   
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //self.view.bringSubviewToFront(myTableView)
        
        detailsCustomer()
        
        
        
    }
    
    func detailsCustomer() {
        for iCutomer in dataDidFilter {
            if let locationOrder = iCutomer.elem?.locationOrder,
               let kyokyusetsubiCode = iCutomer.asset?.properties?.values.kyokyusetsubi_code,
               let customerName = iCutomer.asset?.properties?.values.customer_name,
               let plannedDate = iCutomer.elem?.metadata?.planned_date {
                arrLocationOrder.append(locationOrder)
                arrKyokyusetsubi_code.append(kyokyusetsubiCode)
                arrCustomer_name.append(customerName)
                arrPlanned_date.append(plannedDate)
                
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
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "ContentReplanTableViewCell", for: indexPath) as? ContentReplanTableViewCell
        // ngày 1 exclude_firstday
        
        // từ ngày 2 move_to_first = false
        print((infomationDelivery.elem?.location?.metadata?.display_data?.move_to_firstday = false) != nil)
        //if ((infomationDelivery.elem?.location?.metadata?.display_data?.move_to_firstday = false) != nil) {
            cell?.lbl_kyokyusetsubi_code.text = arrKyokyusetsubi_code[indexPath.row]
            
            cell?.lbl_locationOrder.layer.borderWidth = 1
            cell?.lbl_locationOrder.layer.borderColor = UIColor.black.cgColor
            cell?.lbl_locationOrder.textAlignment = .center
            cell?.lbl_locationOrder.layer.cornerRadius = (cell?.lbl_locationOrder.frame.size.width ?? 45) / 2
            cell?.lbl_locationOrder.layer.masksToBounds = true
            
            cell?.lbl_locationOrder.text = "\(arrLocationOrder[indexPath.row] - 1)"
            cell?.lbl_customer_name.text = arrCustomer_name[indexPath.row]
            
            cell?.lbl_planned_date.text = arrStringDateMMDD[indexPath.row]
            
            cell?.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
      //  }
        
        
        // move_to_firstday = true -> to den cell
        
        selectedRows1.forEach() { cellDidSelected in
            
            if indexPath.row == cellDidSelected {
                cell?.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
                cell?.contentView.backgroundColor = .darkGray
            } else {
                print("\(indexPath.row)")
            }
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrKyokyusetsubi_code.count
    }
    
    
    // myTable view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = myTableView.cellForRow(at: indexPath) as? ContentReplanTableViewCell else { return }
        cell.selectionStyle = .none
        
        myTableView.deselectRow(at: indexPath, animated: false)
        
        if self.selectedRows.contains(indexPath) {
            // uncheck
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
            
            infomationDelivery.elem?.location?.metadata?.display_data?.move_to_firstday = false
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
            delegateContenReplant?.unselected(index: indexPath.row, assetID: arrAssetID[indexPath.row])
            
        } else {
            // click cell add
            // move_to_firstday = true
            
            self.selectedRows.append(indexPath)
            
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
            
            // chuyen move_to_firstday = true 
            infomationDelivery.elem?.location?.metadata?.display_data?.move_to_firstday = true
            
            
            delegateContenReplant?.passData(index: indexPath.row, assetID: arrAssetID[indexPath.row])
            
        }
    }
    
}
