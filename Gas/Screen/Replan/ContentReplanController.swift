//
//  ContentReplanController.swift
//  Gas
//
//  Created by Vuong The Vu on 28/09/2022.
//

import UIKit


protocol MoveToFirstDayDelegateProtocol: AnyObject {
    func passData(isCustomer: Location, indexDate: Int, indexDriver: Int)
    func unselected(isCustomer: Location, indexDate: Int, indexDriver: Int)
 //   func passDicMoveToMini(indexDriver: Int, indexDate: Int, dataDicMoveTo: [Int: [Location]])
}
protocol ExcludeFirstDayDelegateProtocol: AnyObject {
   // func check(isCustomer: Location, indexDriver: Int, indexDate: Int)
   // func uncheck(isCustomer: Location, indexDriver: Int, indexDate: Int)
   
}

class ContentReplanController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegateContenReplant: MoveToFirstDayDelegateProtocol?
    weak var delegateExclude_Replan: ExcludeFirstDayDelegateProtocol?
    
    var dicData: [Date: [Location]] = [:]
    var dateYMD: [Date] = []
    var selectedIdxDate = 0
    var selectedIdxDriver = 0
    var selectedRows = [IndexPath]()
    
    var isCustomer: Location = Location(elem: LocationElement(locationOrder: 0), asset: GetAsset())
    
    var listExclude: [Location] = []
    var dicMoveTo: [Int: [Location]] = [:]
    
    var dataDidFilter_Content: [Location] = []
    var arrAssetID: [String] = []
 
    var dataIsCustomer: [Location] = []
    var listMoveTo: [Location] = []
    var arrAssetIDDidSelected = [String]()
    
    
    
    var listExcludeLocation = [Location]()
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //        if let dataDidFilter_Content = dicData[dateYMD[selectedIdxDate]] {
        //            self.dataDidFilter_Content = dataDidFilter_Content
        //        }
//        dataDidFilter_Content = getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver) //  data goc
        
//        for idetailMoveTo in dicMoveTo {
//            for ivalue in idetailMoveTo.value where ivalue.elem?.location?.metadata?.display_data?.moveToFirstDay != true {
//                ivalue.elem?.location?.metadata?.display_data?.moveToFirstDay = true
//            }
//        }
//
//        for idetailMoveTo in dicMoveTo {
//            for ivalue in idetailMoveTo.value  {
//                print(ivalue.elem?.location?.metadata?.display_data?.moveToFirstDay)
//            }
//        }
//
//        if selectedIdxDate > 0 {
//            for idetailMoveTo in dicMoveTo where idetailMoveTo.key == selectedIdxDate {
//                dataDidFilter_Content.enumerated().forEach { ind, ivalue in
//
//                }
//            }
//        }
    }
    
//    func getDataFiltered(date: Date, driver: Int) -> [Location] {
//        var locationsByDriver: [Int: [Location]] = [:]
//        var elemLocationADay = dicData[date] ?? []
//
//        var indxes = [Int]()
//        // chia ra xe trong 1 ngay
//
//        if elemLocationADay.count > 0 && elemLocationADay[0].type == .supplier && elemLocationADay[0].elem?.locationOrder == 1 {
//            elemLocationADay.remove(at: 0)
//        }
//        indxes = []
//        elemLocationADay.enumerated().forEach { vehicleIdx, vehicle in
//            if (vehicle.type == .supplier) {
//                indxes.append(vehicleIdx)
//            }
//        }
//        indxes.enumerated().forEach { idx, item in
//
//            if Array(elemLocationADay).count > 0 {
//                if idx == 0 && indxes[0] > 0 {
//                    locationsByDriver[idx] = Array(elemLocationADay[0...indxes[idx]])
//                } else if indxes[idx-1]+1 < indxes[idx] {
//                    locationsByDriver[idx] = Array(elemLocationADay[indxes[idx-1]+1...indxes[idx]])
//                }
//            }
//        }
//        self.selectedIdxDriver = driver
//        dataDidFilter_Content = locationsByDriver[driver] ?? []
//        return dataDidFilter_Content
//    }
    
    
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
        
        if selectedIdxDate == 0 && dicData[dateYMD[0]]?[indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay != true {
            // ve ra ngay mot
            //            dicData[dateYMD[0]]?[indexPath.row].type == .supplier
            
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
            
        } else {
            
            // ve ra ngay sau
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
        }
        
        
        // move_to_firstday = true -> to den cell
        // trong object co truong move_to_firstday = true
        
        
        //        if selectedIdxDate != 0 {
        //
        //        } else { // ngay dau khong co mau
        //
        //            // duoc hien thi excludeFirstDay = false
        //            if dicData[dateYMD[0]]![indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay == false &&
        //                 dicData[dateYMD[0]]![indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay == nil {
        //                print("sssssssssssssssssssssssss")
        //            }
        //
        //        }
        
        
        if  dataDidFilter_Content[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay == true && selectedIdxDate != 0  {
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
            cell.contentView.backgroundColor = .darkGray
        } else {
            cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
            cell.contentView.backgroundColor = .systemBackground
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listExcludeLocation.count > 0 {
            print("\(dataDidFilter_Content.count) - \(listExcludeLocation.count)")
            let number = dataDidFilter_Content.count - listExcludeLocation.count
            return number - 1
        } else {
            return dataDidFilter_Content.count - 1
        }
    }
    
    
    // myTable view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = myTableView.cellForRow(at: indexPath) as? ContentReplanTableViewCell else { return }
        
        if selectedIdxDate == 0  {
            // tao ra danh sach moi   sau cac xe cua ngay 1
            // la ngay dau tien chi dc exclude_firstday
            if self.selectedRows.contains(indexPath) {
                // uncheck
                // move_to_firstday = false
                self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
                
             //   delegateExclude_Replan?.uncheck(isCustomer: (dicData[dateYMD[selectedIdxDate]]?[indexPath.row])!, indexDriver: selectedIdxDriver, indexDate: selectedIdxDate)
                
            } else {
                // click cell add
                // move_to_firstday = true
                self.selectedRows.append(indexPath)
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
                
                // chuyen move_to_firstday = true
                // tao khi khong co properties: move_to_firstday
                //                if dataDidFilter_Content[indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay == nil || dataDidFilter_Content[indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay == false {
                //                    dataDidFilter_Content[indexPath.row].elem?.location?.metadata?.display_data?.excludeFirstDay = true
                //                }
                // listExclude.append((dicData[dateYMD[0]]?[indexPath.row])!)
             //   delegateExclude_Replan?.check(isCustomer: dataDidFilter_Content[indexPath.row], indexDriver: selectedIdxDriver, indexDate: selectedIdxDate)
            }
            
        } else {
            // chi dược move_to_firstday
            if self.selectedRows.contains(indexPath) {
                // uncheck
                self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_off"), for: .normal)
                
                delegateContenReplant?.unselected(isCustomer: dataDidFilter_Content[indexPath.row], indexDate: selectedIdxDate, indexDriver: selectedIdxDriver)
                
//                if !listMoveTo.isEmpty {
//                    listMoveTo.enumerated().forEach { ind, ilocation in
//                        if ilocation == dataDidFilter_Content[indexPath.row] {
//                            listMoveTo.remove(at: ind)
//                        }
//                    }
//                }
//                dicMoveTo.updateValue(listMoveTo, forKey: selectedIdxDate)
            } else {
                // click cell add
                self.selectedRows.append(indexPath)
                cell.btnCheckbox.setImage(UIImage(named: "ic_check_on"), for: .normal)
                
                // chuyen move_to_firstday = true
                // tao khi khong co properties: move_to_firstday
                //                if dataDidFilter_Content[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay == nil || dataDidFilter_Content[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay == false {
                //                    dataDidFilter_Content[indexPath.row].elem?.location?.metadata?.display_data?.moveToFirstDay = true
                //                }
                 
//                listMoveTo.append(dataDidFilter_Content[indexPath.row])
//                dicMoveTo.updateValue(listMoveTo, forKey: selectedIdxDate)
                delegateContenReplant?.passData(isCustomer: dataDidFilter_Content[indexPath.row], indexDate: selectedIdxDate, indexDriver: selectedIdxDriver)
            }
//            delegateContenReplant?.passDicMoveToMini(indexDriver: selectedIdxDriver, indexDate: selectedIdxDate, dataDicMoveTo: dicMoveTo)
        }
    }
    
}
