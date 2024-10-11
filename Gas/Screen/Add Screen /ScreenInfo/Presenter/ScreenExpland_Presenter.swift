//
//  ScreenExpland_Presenter.swift
//  Gas
//
//  Created by Vuong The Vu on 14/02/2023.
//

import Foundation

protocol PassDelegateProtocol: AnyObject {
    func loadDataSource()
    func LoginOK(dicData: [Date: [Location]])
    func errorGetMe(error: Error)
    func errorGetLastWorkerLocationList(error: Error)
}

class ScreenExpland_Presenter {
    
    weak var loadDataDelegate: PassDelegateProtocol?
    
    
    var listStringTypeDate: [String] = []
    var companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    
    
    func sevenDay() -> [Date] {
        var listDate: [Date] = []
//        let anchor = Date()
//        let calendar = Calendar.current
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        for dayOffset in 0...6 {
//            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor)?.removeTimeStamp {
//                listDate.append(date1)
//            }
//        }
        return listDate
    }
    
//    func arrStringDate() -> [String] {
    
////        sevenDay()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd"
//        for iday in listDate {
//            let stringDay = formatter.string(from: iday)
//                listStringTypeDate.append(stringDay)
//        }
//        
//        loadDataDelegate?.loadDataSource()
//        return listStringTypeDate
//    }
    
    func requestAPI() async -> [Date: [Location]] {
        var dicData: [Date: [Location]] = [:]
        let listDate = sevenDay()
        // call getMe
        do {
            
            let asset: [Int] = try await GetMe_Async_Await().getMe_Async_Await(companyCode: "\(companyCode)")
            print(asset)
            do {
                // call GetWorkerRouteLocationList_Async_Await
               dicData = try await GetWorkerRouteLocationList_Async_Await().loadDic(dates: listDate)
                print(dicData)// nhan tu view sang
                
//                DispatchQueue.main.async {
//                    self.loadDataDelegate?.LoginOK(dicData: self.dicData)
//                }
                loadDataDelegate?.LoginOK(dicData: dicData)
                
            } catch {
                loadDataDelegate?.errorGetLastWorkerLocationList(error: error)
                
            }
        } catch {
            loadDataDelegate?.errorGetMe(error: error)
        }
        return dicData
    }
    
}
