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
    var arrLocationElem : [LocationElement] = []
    var arrLocation: [Location] = []
    var url: String? = nil
    
    enum AFError: Error {
        case notDelivery
        case tokenOutOfDate
        case wrong
        case remain
    }
    
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
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func getLocationElem_Async_Await(iday: Date) async throws -> [Location] {
        sevenDay()
        let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateString: String = formatter.string(from: iday)
        let url: String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(dateString)"
        
        let getWorkerRouteLocationList = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.makeHeaders(token: token)).validate(statusCode: (200...299))
            .serializingDecodable(GetLatestWorkerRouteLocationListInfo.self)
        let getWorkerRouteLocationListResponse =  await getWorkerRouteLocationList.response
        
        switch getWorkerRouteLocationListResponse.result {
        case .success(_):
            let countObject = getWorkerRouteLocationListResponse.value?.locations?.count
            let locations1: [LocationElement] = getWorkerRouteLocationListResponse.value?.locations ?? []
            if countObject != 0 {
                var arrLocationValue: [Location] = []
                for itemObject in locations1 {
                    arrLocationValue.append(Location.init(elem: itemObject, asset: nil))
                }
                
                arrLocationElem = locations1
                
                for iLocationValue in arrLocationValue {
                    if let assetID = iLocationValue.elem?.location?.assetID {
                        async let getAssetResponse = try? await GetAsset_Async_Await().getGetAsset_Async_Await(forAsset: assetID)
                        iLocationValue.asset = await getAssetResponse
                        await print(getAssetResponse!)
                    } else { print("No assetID -> Supplier") }
                }
                
                //                    self.dicData[iday] = arrLocationValue
                arrLocation = arrLocationValue
            } else {
                print(getWorkerRouteLocationListResponse.response?.statusCode as Any)
                print("\(url) =>> Array Empty, No Object ")
            }
            
            
        case .failure(let error):
            print(url)
            print("Error: \(getWorkerRouteLocationListResponse.response?.statusCode ?? 000000)")
            print("Error: \(error)")
            if getWorkerRouteLocationListResponse.response?.statusCode == 204 {
                throw AFError.notDelivery
            } else if getWorkerRouteLocationListResponse.response?.statusCode == 401 {
                throw AFError.tokenOutOfDate
            } else if getWorkerRouteLocationListResponse.response?.statusCode == 404 {
                // throw AFError.wrong
            } else {
//                                 throw AFError.remain
            }
        }
        
        return arrLocation
    }
    
    func loadDic(dates: [Date]) async -> [Date: [Location]] {
        await withTaskGroup(
            of: (Date, [Location]).self,
            returning: [Date: [Location]].self) { [self] group in
                // co key: location elem
                
                // group la 1 mang location elem la KQ cua func
                var dicData: [Date: [Location]] = [:]
                for iday in dates {
                    group.addTask { await (iday, try! self.getLocationElem_Async_Await(iday: iday)) }
                }
                // dic: location
                for await result in group {
                    dicData[result.0] = result.1
                }
                return dicData
            }
    }
    
    
}
