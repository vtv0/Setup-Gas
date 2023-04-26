//
//  ScreenExpland_Presenter.swift
//  Gas
//
//  Created by Vuong The Vu on 14/02/2023.
//

import UIKit
import Alamofire

protocol Login_Block: AnyObject {
    func login(dicData: [Date: [Location]], createdAt: String?)
}

protocol PassDelegateProtocol: AnyObject {
    func LoginOK(dicData: [Date: [Location]], date7: [Date])
    func errorGetMe(error: Error)
    func errorGetLastWorkerLocationList(error: Error)
}

class ScreenExpland_Presenter {
    weak var loadDataDelegate: PassDelegateProtocol?
    weak var delegateLoginBlock: Login_Block?
    var listStringTypeDate: [String] = []
    var companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""

    func sevenDay() -> [Date] {
        var listDate: [Date] = []
        let calendar = Calendar.current
        let anchor = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor)?.removeTimeStamp {
                listDate.append(date1)
            }
        }
        return listDate
    }
    
    func requestAPI() async -> [Date: [Location]] {
        var dicData: [Date: [Location]] = [:]
        let listDate = sevenDay()
        do {
            let asset: [Int] = try await GetMe_Async_Await().getMe_Async_Await(companyCode: "\(companyCode)")
            print(asset)
            do {
                dicData = await GetWorkerRouteLocationList_Async_Await().loadDic(dates: listDate)
                print(dicData)// nhan tu view sang
                
                loadDataDelegate?.LoginOK(dicData: dicData, date7: listDate)
                
            } 
        } catch {
            loadDataDelegate?.errorGetMe(error: error)
        }
        return dicData
    }
    
    func callAPI_Block() {
        GetMe_Block().getMe_Block(commpanyCode: "\(companyCode)", acccessToken:  UserDefaults.standard.string(forKey: "accessToken") ?? "", completion: { arrayInt, err  in
            if let errorGetMe = err {
                self.loadDataDelegate?.errorGetMe(error: errorGetMe)
            } else {  // error nil -> arrayInt has data
                GetWorkerRouteLocationList_Block().getWorkerRouteLocationList_Block(tenantId: arrayInt[0], userId: arrayInt[1], completion: { dic, errorGetElem, createdAt  in
                    if let err = errorGetElem {
                        self.loadDataDelegate?.errorGetLastWorkerLocationList(error: err)
                    } else {
                        self.delegateLoginBlock?.login(dicData: dic, createdAt: createdAt as? String )
                    }
                })
            }
        })
    }
    
    
}
