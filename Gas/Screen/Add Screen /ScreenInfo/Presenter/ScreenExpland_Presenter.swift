//
//  ScreenExpland_Presenter.swift
//  Gas
//
//  Created by Vuong The Vu on 14/02/2023.
//

import Foundation

protocol PassDelegateProtocol: AnyObject {
    func loadDataSource()
    func LoginOK()
}

class ScreenExpland_Presenter {
    
    weak var loadDataDelegate: PassDelegateProtocol?
    
    var listDate: [Date] = []
    var listStringTypeDate: [String] = []
    
    
    func sevenDay() {
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor)?.removeTimeStamp {
                listDate.append(date1)
            }
        }
    }
    
    func arrStringDate() -> [String] {
        sevenDay()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        for iday in listDate {
            let stringDay = formatter.string(from: iday)
                listStringTypeDate.append(stringDay)
        }
        
        loadDataDelegate?.loadDataSource()
        return listStringTypeDate
    }
    
    func requestAPI() async {
        
        do {
            let asset: [Int] = try await GetMe_Async_Await().getMe_Async_Await(companyCode: "am-stg-iw01j")
            print(asset)
            do {
               let dicData = try await GetWorkerRouteLocationList_Async_Await().loadDic(dates: listDate)
                print(dicData)// nhan tu view sang
                
                DispatchQueue.main.async {
                    self.loadDataDelegate?.LoginOK()
                }
                loadDataDelegate?.LoginOK()
                
            } catch {
                
            }
            
            
        } catch {
            
        }
    }
    
}
