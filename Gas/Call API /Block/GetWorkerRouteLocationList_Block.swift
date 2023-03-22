//
//  GetWorkerRouteLocationList_Block.swift
//  Gas
//
//  Created by Vuong The Vu on 12/01/2023.
//

import UIKit
import Alamofire



class GetWorkerRouteLocationList_Block {
    
    var dateYMD: [Date] = []
    var dicData: [Date: [Location]] = [:]
    let url: String? = nil
    
    let group = DispatchGroup()
    
    enum CaseError: Error {
        case tokenOutOfDate
        case wrong
        case remaining
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
    
    func getWorkerRouteLocationList_Block(tenantId: Int, userId: Int, completion: @escaping ((Dictionary<Date, [Location]>, (CaseError?), (String?)?) -> Void)) {
        sevenDay()
        var tDay: Int = 0
        var numberCallGetAsset: Int = 0
        var numberHasAssetID : Int = 0
        let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        for iday in dateYMD {
            let dateString: String = formatter.string(from: iday)
            let url: String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(dateString)"
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default ,headers: self.makeHeaders(token: token)).validate(statusCode: (200...299))
            
                .responseDecodable(of: GetLatestWorkerRouteLocationListInfo.self) { response in
                    tDay += 1
                    switch response.result {
                    case .success(let data):
                        let dispatchGroup = DispatchGroup()
                        let countObject = response.value?.locations?.count
                        let locations1: [LocationElement] = data.locations ?? []
                        
                        let workerRoute_createedAt = data.workerRoute?.createdAt ?? ""
                        //                        print(workerRoute_createedAt)
                        
                        if countObject != 0 {
                            
                            var arrLocationValue: [Location] = []
                            for ilocationValue in locations1 where ilocationValue.location?.assetID != nil {
                                numberHasAssetID += 1
                            }
                            
                            for itemObject in locations1 {
                                arrLocationValue.append(Location.init(elem: itemObject, asset: nil, createdAt: workerRoute_createedAt))  // moi co data cua elem
                            }
                            
                            // kieem tra xem AssetID da co trong DB asset chua
                            for iLocationValue in arrLocationValue {
                                numberCallGetAsset += 1
                                if let iassetDB = DBLocation.shared.selectDataAsset(ilocation: iLocationValue) {
                                    iLocationValue.asset = iassetDB
                                } else {  // goi API
//                                    dispatchGroup.enter()
                                    if let assetID = iLocationValue.elem?.location?.assetID {
                                        GetAsset_Block().getGetAsset_Block(iassetID: assetID) { iasset, err2  in
                                            if let iAsset = iasset {
                                                iLocationValue.asset = iasset  // gan vao model
                                                DBLocation.shared.insertDataAsset(iGetAsset: iAsset)  // INSERT VAO DB
                                               
                                            }
//                                            dispatchGroup.leave()
                                        }
                                    }
                                }
                            }
                            
                            self.dicData[iday] = arrLocationValue
                            
                            if tDay == self.dateYMD.count {
                                dispatchGroup.notify(queue: .main) {
                                    completion(self.dicData, nil, workerRoute_createedAt)
                                }
                            }
                            
                        } else {
                            print(response.response?.statusCode as Any)
                            print("\(url) =>> Array Empty, No Object ")
                        }
                        
                    case .failure(_):
                        print("Error: \(response.response?.statusCode ?? 000000)")
                        if response.response?.statusCode == 401 {
                            completion([:], CaseError.tokenOutOfDate, nil)
                        } else if response.response?.statusCode == 204 {
                            completion([:], CaseError.wrong, nil)
                        } else {
                            completion([:], CaseError.remaining, nil)
                        }
                    }
                    
                    
                }
        }
        
    }
    
}

