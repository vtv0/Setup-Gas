//
//  ContentReplanController.swift
//  Gas
//
//  Created by Vuong The Vu on 28/09/2022.
//

import UIKit

protocol PassDataDelegateProtocol: AnyObject {
    func check(isCustomer: Location, indexDriver: Int, indexDate: Int, indexPath: Int)
    func uncheck(isCustomer: Location, indexDriver: Int, indexDate: Int, indexPath: Int)
}

class ContentReplanController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    weak var delegatePassData: PassDataDelegateProtocol?
    
    var dicData: [Date: [Location]] = [:]
    var dateYMD: [Date] = []
    var selectedIdxDate = 0
    var selectedIdxDriver = 0
    var selectedRows = [IndexPath]()
    var isCustomer: Location = Location(elem: LocationElement(locationOrder: 0), asset: GetAsset())
    
    var dicExclude: [Int: [Location]] = [:]
    var dicMoveTo: [Int: [Location]] = [:]
    
    var dataDidFilter_Content: [Location] = []
    var arrAssetID: [String] = []
    
    var indxes = [Int]()
    var listMoveTo: [Location] = []
    var listExcludeLocation = [Location]()
    
    var arrIsCustomer = [Location]()
    
    var backList = [Location]()
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.reloadData()
        for iCustomer in dataDidFilter_Content where iCustomer.type == .customer {
            arrIsCustomer.append(iCustomer)
        }
        myTableView.dataSource = self
        myTableView.delegate = self
    }
    
    // myTableView dataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        selectedRows.removeAll()    
        let cell = myTableView.dequeueReusableCell(withIdentifier: "ContentReplanTableViewCell", for: indexPath) as! ContentReplanTableViewCell
        
        
        // binh thuong
        cell.lbl_locationOrder.text = "\((dataDidFilter_Content[indexPath.row].elem?.locationOrder ?? 0) - 1)"
        cell.lbl_kyokyusetsubi_code.text = dataDidFilter_Content[indexPath.row].asset?.properties?.values.kyokyusetsubi_code
        
        cell.lbl_locationOrder.layer.borderWidth = 1
        cell.lbl_locationOrder.layer.borderColor = UIColor.black.cgColor
        cell.lbl_locationOrder.textAlignment = .center
        cell.lbl_locationOrder.layer.cornerRadius = (cell.lbl_locationOrder.frame.size.width) / 2
        cell.lbl_locationOrder.layer.masksToBounds = true
        
        cell.lbl_customer_name.text = dataDidFilter_Content[indexPath.row].asset?.properties?.values.customer_name
        
        if let iday = dataDidFilter_Content[indexPath.row].elem?.metadata?.planned_date {
            let dateFomatter = DateFormatter()
            dateFomatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFomatter.date(from: iday) {
                dateFomatter.dateFormat = "MM/dd"
                let stringDate = dateFomatter.string(from: date)
                cell.lbl_planned_date.text = stringDate
            }
        }
        
        if  dataDidFilter_Content[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay == true && selectedIdxDate != 0 {
            
           cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
            cell.contentView.backgroundColor = .darkGray
        } else {
            cell.contentView.backgroundColor = .systemBackground
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
        }
        
        if selectedRows.contains(indexPath) {
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
        }
//        else {
//            cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
//        }
        
        return cell
    }
    
    
    // myTableView dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrIsCustomer.count
    }
    
    // myTable view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = myTableView.cellForRow(at: indexPath) as? ContentReplanTableViewCell else { return }
        if self.selectedRows.contains(indexPath) {
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
            delegatePassData?.uncheck(isCustomer: dataDidFilter_Content[indexPath.row], indexDriver: selectedIdxDriver, indexDate: selectedIdxDate, indexPath: indexPath.row)
        } else {
            self.selectedRows.append(indexPath)
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
            delegatePassData?.check(isCustomer: dataDidFilter_Content[indexPath.row], indexDriver: selectedIdxDriver, indexDate: selectedIdxDate, indexPath: indexPath.row)
        }
    }
    
    
    
    
    
}
