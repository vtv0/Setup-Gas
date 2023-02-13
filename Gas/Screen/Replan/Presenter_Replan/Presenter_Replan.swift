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
    
    func getDataFiltered(date: Date, driver: Int, dicData: [Date: [Location]]) -> [Location] {
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
    
    
    
    
}
