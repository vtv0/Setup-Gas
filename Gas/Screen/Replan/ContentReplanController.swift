//
//  ContentReplanController.swift
//  Gas
//
//  Created by Vuong The Vu on 28/09/2022.
//

import UIKit

protocol InfoACellDelegateProtocol: AnyObject {
    func passData(index: Int, info: String)
    func unselected(index: Int)
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
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //self.view.bringSubviewToFront(myTableView)
        
        detailsCustomer()
        print(selectedRows1)
       // self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
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
    
        func deleteRows() {
            if let selectedRows = myTableView.indexPathsForSelectedRows {
                // 1
                var items = [String]()
                for indexPath in selectedRows  {
                    items.append(arrCustomer_name[indexPath.row])
                }
    
                // 2
                for item in items {
                    if let index = arrCustomer_name.firstIndex(of: item) {
                        arrCustomer_name.remove(at: index)
                    }
                }
                // 3
                myTableView.deleteRows(at: selectedRows, with: .automatic)
                myTableView.reloadData()
            }
        }
    
    
    // myTableView dataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "ContentReplanTableViewCell", for: indexPath) as? ContentReplanTableViewCell
        
        cell?.lbl_kyokyusetsubi_code.text = arrKyokyusetsubi_code[indexPath.row]
        
        cell?.lbl_locationOrder.layer.borderWidth = 1
        cell?.lbl_locationOrder.layer.borderColor = UIColor.black.cgColor
        cell?.lbl_locationOrder.textAlignment = .center
        cell?.lbl_locationOrder.layer.cornerRadius = (cell?.lbl_locationOrder.frame.size.width ?? 0) / 2
        cell?.lbl_locationOrder.layer.masksToBounds = true
        
        cell?.lbl_locationOrder.text = "\(arrLocationOrder[indexPath.row] - 1)"
        cell?.lbl_customer_name.text = arrCustomer_name[indexPath.row]
        
        
        cell?.lbl_planned_date.text = arrStringDateMMDD[indexPath.row]
        cell?.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
        
       // cell?.backgroundColor = .darkGray
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrKyokyusetsubi_code.count
    }
    
    
    // delete cell did selectedm in tableview
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return false
//
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//
//
//    }
    
    
    // myTable view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = myTableView.cellForRow(at: indexPath) as? ContentReplanTableViewCell else { return }
        cell.selectionStyle = .none
        myTableView.deselectRow(at: indexPath, animated: false)
        
        if self.selectedRows.contains(indexPath) {
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
            delegateContenReplant?.unselected(index: indexPath.row)
        } else {
            self.selectedRows.append(indexPath)
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)

            delegateContenReplant?.passData(index: indexPath.row, info: "")
        }
    }
    
}
