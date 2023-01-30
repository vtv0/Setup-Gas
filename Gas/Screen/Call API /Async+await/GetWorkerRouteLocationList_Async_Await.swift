//
//  GetWorkerRouteLocationList_Async_Await.swift
//  Gas
//
//  Created by Vuong The Vu on 13/01/2023.
//

import UIKit
import Alamofire

class GetWorkerRouteLocationList_Async_Await {
    
    var dateYMD: [Date] = []
    var dicData: [Date: [Location]] = [:]
    var url: String? = nil
    
    
    //    init(url: String?) {
    //        self.url = url
    //
    //    }
    enum CaseError: Error {
        case ok
        case tokenOutOfDate
        case wrongPassword
        case remain
    }
    
    func sevenDay() {
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                dateYMD.append(date1)
            }
        }
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func getWorkerRouteLocationList_Async_Await() async throws -> Dictionary<Date, [Location]> {
        
        let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        sevenDay()
        var t = 0
        let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    
        for iday in dateYMD {
            let dateString: String = formatter.string(from: iday)
            let url: String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(dateString)"
            
                AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default ,headers: self.makeHeaders(token: token)).validate(statusCode: (200...299))
                    .responseDecodable(of: GetLatestWorkerRouteLocationListInfo.self) { response in
                        t += 1
                        switch response.result {
                        case .success(_):
                            let countObject = response.value?.locations?.count
                            let locations1: [LocationElement] = response.value?.locations ?? []
                            if countObject != 0 {
                                var arrLocationValue: [Location] = []
                                for ilocationValue in locations1 where ilocationValue.location?.assetID != nil {
                                    //                                self.numberAssetIDOf7Date += 1
                                }
                                
                                for itemObject in locations1 {
                                    arrLocationValue.append(Location.init(elem: itemObject, asset: nil))
                                }
                                
                                for iLocationValue in arrLocationValue {
                                    if let assetID = iLocationValue.elem?.location?.assetID {
                                        GetAsset_Block().getGetAsset_Block(forAsset: assetID) { iasset, err2  in
                                            iLocationValue.asset = iasset
                                        }
                                    } else { print("No assetID -> Supplier") }
                                }
                                self.dicData[iday] = arrLocationValue
                            } else {
                                print(response.response?.statusCode as Any)
                                print("\(url) =>> Array Empty, No Object ")
                            }
                           
                            
                        case .failure(let error):
                            print("Error: \(response.response?.statusCode ?? 000000)")
                            print("Error: \(error)")
                        }
                    }
            }
        
        return dicData
    }
}
