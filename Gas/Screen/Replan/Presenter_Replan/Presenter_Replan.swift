//
//  Presenter_Replan.swift
//  Gas
//
//  Created by Vuong The Vu on 13/02/2023.
//

import Foundation

protocol ReplanDelegateProtocol: AnyObject {
    func loadInfomationForMKMap(dataDidFilter_Replan: [Location], arrMoveToIsTrue: [Location])
}

class Persenter_Replan {
    weak var delegateReplan: ReplanDelegateProtocol?
    
    var dicData: [Date : [Location]] = [:]
    var indxes = [Int]()
    var dataDidFilter_Replan = [Location]()
    var dateYMD: [Date] = []
    var selectedIdxDate = 0
    var selectedIdxDriver = 0
    var listLastIndDriver = [Int]()
    var lastIndDriver1 = 0
    var lastIndDriver2 = 0
    
    
    func sevenDay() {
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor)?.removeTimeStamp {
                dateYMD.append(date1)
            }
        }
    }
    
    //    func presenter_Replan() {
    //        delegateReplan?.loadInfomationForMKMap(dataDidFilter_Replan: <#[Location]#>, arrMoveToIsTrue: <#[Location]#>)
    //    }
    
    
    //    enum quantityOfEachType {
    //        case lblType50kg
    //        case lblType30kg
    //        case lblType25kg
    //        case lblType20kg
    //        case lblTypeOther
    //    }
    
    //    func totalType(EachType: Int) {
    //        var numberType50: Int = 0
    //        var numberType30: Int = 0
    //        var numberType25: Int = 0
    //        var numberType20: Int = 0
    //        var numberTypeOther: Int = 0
    //        totalNumberOfBottle = 0
    //
    //        arrFacilityData.removeAll()
    //        for facilityData in dataDidFilter_Replan {
    //            arrFacilityData.append(facilityData.elem?.metadata?.facility_data ?? [])
    //        }
    //
    //        for iFacilityData in arrFacilityData {
    //            for detailFacilityData in iFacilityData {
    //                totalNumberOfBottle += detailFacilityData.count ?? 0
    //                if detailFacilityData.type == 50 {
    //                    numberType50 = numberType50 + (detailFacilityData.count ?? 0)
    //                } else if detailFacilityData.type == 30 {
    //                    numberType30 = numberType30 + (detailFacilityData.count ?? 0)
    //                } else if detailFacilityData.type == 25 {
    //                    numberType25 = numberType25 + (detailFacilityData.count ?? 0)
    //                } else if detailFacilityData.type == 20 {
    //                    numberType20 = numberType20 + (detailFacilityData.count ?? 0)
    //                } else {
    //                    numberTypeOther = numberTypeOther + (detailFacilityData.count ?? 0)
    //                }
    //            }
    //        }
    //        lblType50kg.text = "\(numberType50)"
    //        lblType30kg.text = "\(numberType30)"
    //        lblType25kg.text = "\(numberType25)"
    //        lblType20kg.text = "\(numberType20)"
    //        lblTypeOther.text = "\(numberTypeOther)"
    //
    //        //return .lblTypeOther
    //    }
    
    func reDrawMarkers() {
        //        dataDidFilter_Replan.removeAll()
        //        arrLocationOrder.removeAll()
        //        if mapView != nil {
        //            mapView.removeAnnotations(mapView.annotations)
        //        }
        
        dataDidFilter_Replan = getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver)
        
        // them du lieu vao Driver Remove
        var listRemoveOK : [Location] = []
        if selectedIdxDate == 0 && selectedIdxDriver + 1 == indxes.count + 1 {  // ExcludeFirst == True
            for idic in dicData {
                if idic.key == dateYMD.first {
                    for ilocation in idic.value where ilocation.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                        listRemoveOK.append(ilocation)
                    }
                    dataDidFilter_Replan = listRemoveOK  // tao ra ds Remove
                }
            }
        }
        
        // xoa data  ngay 1 xe 1 || exclude == true
        var listRemove = [Location]()
        var listRemove1 = [Location]()
        if listRemove.count > 0 {
            if selectedIdxDate == 0 && selectedIdxDriver + 1 < indxes.count + 1 {
                for idic in dicData {
                    if idic.key == dateYMD.first {
                        for ilocation in idic.value where ilocation.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                            listRemove1.append(ilocation)
                        }
                    }
                }
//                dataDidFilter_Replan = dataDidFilter_Replan.filter( { !listRemove1.contains($0) } )   // dung logic nhung bi loi
            }
        }
        
        
        // them date vao  Xe cuoi, ngay 1
        var arrMoveToIsTrue = [Location]()
        for idic in dicData {  // Move To firstDay == true
            if idic.key != dateYMD.first {
                for iLocation in idic.value where iLocation.elem?.location?.metadata?.display_data?.moveToFirstDay == true {
                    arrMoveToIsTrue.append(iLocation)
                }
            }
        }
        // xoa data   Xe cuoi, ngay 1
        if arrMoveToIsTrue.count > 0 && selectedIdxDate == 0 && selectedIdxDriver+1 == indxes.count {  // xe cuoi , ngay 1
            dataDidFilter_Replan.insert(contentsOf: arrMoveToIsTrue, at: dataDidFilter_Replan.count - 1)
        } else if arrMoveToIsTrue.count > 0 && selectedIdxDate == 0 && dataDidFilter_Replan.isEmpty {  // ngay 1 khong co data || sau 4h
            //   dataDidFilter_Replan.insert(contentsOf: arrMoveToIsTrue, at: dataDidFilter_Replan.count - 1)
        }
        
        // danh so lai    /// sai vi khi co 3, 4, 5 xe
        var listLocationOrder = [Int]()
        
        // tao [10, 31, 56]
        //        for (ind, ivalue) in indxes.enumerated() {
        //            if ind == 0 {
        //                for (ind, picker) in dataDidFilter_Replan.enumerated() where picker.type == .customer {
        //                    listLocationOrder.append(ind + 1)
        //                    picker.elem?.locationOrder = ind + 1
        //                }
        //                listLastIndDriver.append(listLocationOrder.last ?? 0)
        //                print(listLastIndDriver)
        //            } else if selectedIdxDriver > 0 {
        //
        //            }
        //        }
        
        // thay doi so luong cua tung xe ->  thi duoc cap nhat lai
        //        for idic in dicData where idic.key == dateYMD[selectedIdxDate] {
        //            for (ind, ivalue) in idic.value.enumerated() where ivalue.type == .customer {   // 54 customer
        //                if ivalue.elem?.location?.metadata?.display_data?.moveToFirstDay != true  {
        //                    print(ind)
        //                }
        //            }
        //        }
        
        if selectedIdxDriver == 1 {
            print(dataDidFilter_Replan.count)   // 20 xe
        }
        
        //  danh so cho 3 xe
        if selectedIdxDriver == 0 {
            for (ind, picker) in dataDidFilter_Replan.enumerated() where picker.type == .customer {
                listLocationOrder.append(ind + 1)
                picker.elem?.locationOrder = ind + 1
            }
            lastIndDriver1 = listLocationOrder.last ?? 0
        } else if selectedIdxDriver+1 == indxes.count + 1 {
            for (ind, picker) in dataDidFilter_Replan.enumerated() where picker.type == .customer {
                listLocationOrder.append(ind + 1)
                picker.elem?.locationOrder = ind + 1
            }
        } else if selectedIdxDriver > 0 {
            if selectedIdxDriver == 1 {
                for (ind, picker) in dataDidFilter_Replan.enumerated() where picker.type == .customer {
                    picker.elem?.locationOrder = lastIndDriver1 + 2 + ind
                    listLocationOrder.append(lastIndDriver1 + 2 + ind)
                }
                lastIndDriver2 = listLocationOrder.last ?? 0
            } else if selectedIdxDriver+1 == indxes.count {
                for (ind, picker) in dataDidFilter_Replan.enumerated() where picker.type == .customer {
                    picker.elem?.locationOrder = lastIndDriver2 + 2 + ind
                    listLocationOrder.append(lastIndDriver2 + 2 + ind)
                }
            }
        }
        
        
        //
        //        for idic in dicData where idic.key == dateYMD[selectedIdxDate] {
        //            for (ind, ivalue) in idic.value.enumerated() where ivalue.type == .customer {   // 54 customer
        //                print(ivalue.elem?.locationOrder)
        //            }
        //        }
        
        
        // Marker in MKMap
        print(dataDidFilter_Replan.count)
        
        
        
        
    }
    
    
    // loc ra 1 ngay va 1 xe -> [Location]
    func getDataFiltered(date: Date, driver: Int) -> [Location] {
        
        print(date)
        print(driver)
        sevenDay()
        var locationsByDriver: [Int: [Location]] = [:]
        var elemLocationADay = dicData[date] ?? []
        // chia ra xe trong 1 ngay
        
        if elemLocationADay.count > 0 && elemLocationADay[0].type == .supplier && elemLocationADay[0].elem?.locationOrder == 1 {
            elemLocationADay.remove(at: 0)
        }
        
        indxes = []
        elemLocationADay.enumerated().forEach { vehicleIdx, vehicle in
            if (vehicle.type == .supplier) {
                indxes.append(vehicleIdx)
            }
        }
        indxes.enumerated().forEach { idx, item in
            if Array(elemLocationADay).count > 0 {
                if idx == 0 && indxes[0] > 0 {
                    locationsByDriver[idx] = Array(elemLocationADay[0...indxes[idx]])
                } else if indxes[idx-1]+1 < indxes[idx] {
                    locationsByDriver[idx] = Array(elemLocationADay[indxes[idx-1]+1...indxes[idx]])
                }
            }
        }
        
        self.selectedIdxDriver = driver
        //        self.pickerDriver.reloadAllComponents()
        dataDidFilter_Replan = locationsByDriver[driver] ?? []
        var listMoveToIsTrue: [Location] = []
        if dataDidFilter_Replan.isEmpty {  // hom dau khong co data
            // value 6 ngay con lai
            for idic in dicData where idic.key != dateYMD[0] {
                for ilocation in idic.value where ilocation.elem?.location?.metadata?.display_data?.moveToFirstDay == true {
                    listMoveToIsTrue.append(ilocation)
                }
            }
            if selectedIdxDate == 0 {
                dataDidFilter_Replan = listMoveToIsTrue
            }
        }
        
        var checkListRemove = [Location]()  // check ngay 1 co ds Remove k
        if selectedIdxDate == 0 {
            for idic in dicData where idic.key == dateYMD[0] {
                for ilocation in idic.value where ilocation.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                    checkListRemove.append(ilocation)
                }
            }
        }
        
        var listRemove: [Location] = []
        if selectedIdxDriver + 1 < indxes.count + 1 {
            for idic in dicData {  // Move To firstDay == true
                if idic.key == dateYMD.first {
                    for iLocation in idic.value where iLocation.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                        listRemove.append(iLocation)
                    }
                    if listRemove.count > 0 {
                        //                        delegateReplan?.reDrawMarkers()
                        
                    }
                }
            }
        }
        
        
        if dataDidFilter_Replan.isEmpty && selectedIdxDate == 0 && selectedIdxDriver + 1 == indxes.count + 1 {  // driver Remove Date 1
            dataDidFilter_Replan = listRemove
        }
        
        //        if dataDidFilter_Replan.count > 0 || checkListRemove.count > 0 {
        //            btnReplace.isHidden = false
        //            btnClear.isHidden = false
        //            totalType(EachType: 0)
        //            floatingPanel()
        //            checkListRemove.removeAll()
        //        } else {
        //            fpc.removePanelFromParent(animated: true)
        //            btnReplace.isHidden = true
        //            btnClear.isHidden = true
        //        }
        //        self.pickerDriver.reloadAllComponents()
        print(dataDidFilter_Replan)
        delegateReplan?.loadInfomationForMKMap(dataDidFilter_Replan: dataDidFilter_Replan, arrMoveToIsTrue: listRemove)
        return dataDidFilter_Replan
    }
    
    
    // 1 ngay co bao nhieu xe
//    func getIndxes(date: Date, dicData: [Date: [Location]]) -> [Int] {
//      //  sevenDay()
//        var locationsByDriver: [Int: [Location]] = [:]
//        var elemLocationADay = dicData[date] ?? []
//        // chia ra xe trong 1 ngay
//        
//        if elemLocationADay.count > 0 && elemLocationADay[0].type == .supplier && elemLocationADay[0].elem?.locationOrder == 1 {
//            elemLocationADay.remove(at: 0)
//        }
//        
//        indxes = []
//        elemLocationADay.enumerated().forEach { vehicleIdx, vehicle in
//            if (vehicle.type == .supplier) {
//                indxes.append(vehicleIdx)
//            }
//        }
//        indxes.enumerated().forEach { idx, item in
//            if Array(elemLocationADay).count > 0 {
//                if idx == 0 && indxes[0] > 0 {
//                    locationsByDriver[idx] = Array(elemLocationADay[0...indxes[idx]])
//                } else if indxes[idx-1]+1 < indxes[idx] {
//                    locationsByDriver[idx] = Array(elemLocationADay[indxes[idx-1]+1...indxes[idx]])
//                }
//            }
//        }
//        return indxes
//    }
    
}
