//
//  ContentReplanController.swift
//  Gas
//
//  Created by Vuong The Vu on 28/09/2022.
//

import UIKit

protocol InfoACellDelegateProtocol: AnyObject {
    func passData(index: Int, isCustomer: Location)
    func unselected(index: Int, isCustomer: Location)
}

class ContentReplanController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegateContenReplant: InfoACellDelegateProtocol?
    var selectedRows1: [Int] = []
    
    var selectedRows: [IndexPath] = []
    
    var dataDidFilterContent: [Location] = []
    var arrAssetID: [String] = []
    var isCustomer: Location = Location(elem: LocationElement(locationOrder: 0), asset: GetAsset())
    var dataIsCustomer: [Location] = []
    var arrAssetIDDidSelected = [String]()
    var selectedIdxDate = 0
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        detailsCustomer()
    }
    
    func detailsCustomer() {
        arrAssetID.removeAll()
        
        for iCustomer in dataDidFilterContent where iCustomer.type == .customer {
            dataIsCustomer.append(iCustomer)
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
        cell.lbl_locationOrder.text = "\((dataDidFilterContent[indexPath.row].elem?.locationOrder ?? 0) - 1)"
        cell.lbl_kyokyusetsubi_code.text = dataDidFilterContent[indexPath.row].asset?.properties?.values.kyokyusetsubi_code
        
        cell.lbl_locationOrder.layer.borderWidth = 1
        cell.lbl_locationOrder.layer.borderColor = UIColor.black.cgColor
        cell.lbl_locationOrder.textAlignment = .center
        cell.lbl_locationOrder.layer.cornerRadius = (cell.lbl_locationOrder.frame.size.width) / 2
        cell.lbl_locationOrder.layer.masksToBounds = true
        
        cell.lbl_customer_name.text = dataDidFilterContent[indexPath.row].asset?.properties?.values.customer_name
        
        if let iday = dataDidFilterContent[indexPath.row].elem?.metadata?.planned_date {
            let dateFomatter = DateFormatter()
            dateFomatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFomatter.date(from: iday) {
                dateFomatter.dateFormat = "MM/dd"
                let stringDate = dateFomatter.string(from: date)
                cell.lbl_planned_date.text = stringDate
            }
            
        }
        
        // move_to_firstday = true -> to den cell
        // trong object co truong move_to_firstday = true
        if  dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay == true {
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
            cell.contentView.backgroundColor = .darkGray
        } else {
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
            cell.contentView.backgroundColor = .systemBackground
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDidFilterContent.count - 1
    }
    
    
    // myTable view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = myTableView.cellForRow(at: indexPath) as? ContentReplanTableViewCell else { return }
        
        if selectedIdxDate == 0  {
            // neu la ngay dau tien thi chi dc exclude_firstday
            // tao ra danh sach moi sau cac xe cua ngay 1
            
            if self.selectedRows.contains(indexPath) {
                // uncheck
                self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
                
                
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
                if dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                    dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay = false
                }
                
                // delegateContenReplant?.unselected(index: indexPath.row, assetID: arrAssetID[indexPath.row])
                
            } else {
                // click cell add
                // move_to_firstday = true
                self.selectedRows.append(indexPath)
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
                
                // chuyen move_to_firstday = true
                // tao khi khong co properties: move_to_firstday
                if dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay == nil || dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay == false {
                    dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay = true
                }
                // delegateContenReplant?.passData(index: indexPath.row, assetID: arrAssetID[indexPath.row])
            }
            
        } else {
            // chi dược move_to_firstday
            
            if self.selectedRows.contains(indexPath) {
                // uncheck
                self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
                
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
                if dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay == true {
                    dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay = false
                }
                
                delegateContenReplant?.unselected(index: indexPath.row, isCustomer: dataDidFilterContent[indexPath.row])
                
            } else {
                // click cell add
                // move_to_firstday = true
                self.selectedRows.append(indexPath)
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
                
                // chuyen move_to_firstday = true
                // tao khi khong co properties: move_to_firstday
                if dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay == nil || dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay == false {
                    dataDidFilterContent[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay = true
                }
                delegateContenReplant?.passData(index: indexPath.row, isCustomer: dataDidFilterContent[indexPath.row])
            }
        }
    }
    
}
