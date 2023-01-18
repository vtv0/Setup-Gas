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
    let numberAssetIDOf7Date = 0
  //  let group = DispatchGroup()
    
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
    
    
    func getWorkerRouteLocationList_Block(tenantId: Int, userId: Int, completion: @escaping ((Dictionary<Date, [Location]>?) -> Void)) {
        sevenDay()
        var t = 0
        var companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
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
                    t += 1
                    switch response.result {
                    case .success(let data):
                        
                        let countObject = response.value?.locations?.count
                        let locations1: [LocationElement] = data.locations ?? []
                        if countObject != 0 {
                            var arrLocationValue: [Location] = []
                            for ilocationValue in locations1 where ilocationValue.location?.assetID != nil {
                                // self.numberAssetIDOf7Date += 1
                            }
                            for itemObject in locations1 {
                                arrLocationValue.append(Location.init(elem: itemObject, asset: nil))
                            }
                            //    self.group.enter()
                            for iLocationValue in arrLocationValue {
                                if let assetID = iLocationValue.elem?.location?.assetID {
                                    
                                
                                    GetAsset_Block().getGetAsset_Block(forAsset: assetID) { iasset in
                                        iLocationValue.asset = iasset
                                        //    print("aaAA:")
                                     
                                    }
                                } else { print("No assetID -> Supplier") }
                            }
                             // self.group.leave()
                            
                            
                           // self.group.enter()
                            self.dicData[iday] = arrLocationValue
                           //     print("iiii")
                          //  self.group.leave()
                            
                        } else {
                            print(response.response?.statusCode as Any)
                            print("\(url) =>> Array Empty, No Object ")
                        }
                        
                        //self.group.notify(queue: .main) {
                            completion(self.dicData)
                        //    print("Done")
                       // }
                        
                    case .failure(let error):
                        print("Error: \(response.response?.statusCode ?? 000000)")
                        print("Error: \(error)")
                        completion(nil)
                    }
                }
        }
        
        
    }
    
    
    
    //    func fetchAPI<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> ()) {
    //        URLSession.shared.dataTask(with: url) { data, response, error in
    //            if let error = error {
    //                completion(.failure(error))
    //                return
    //            }
    //
    //            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
    //                completion(.failure(APIError.error("Bad HTTP Response")))
    //                return
    //            }
    //
    //            do {
    //                let decodedData = try JSONDecoder().decode(T.self, from: data)
    //                completion(.success(decodedData))
    //            } catch {
    //                completion(.failure(error))
    //            }
    //        }
    //        .resume()
    //    }
    //
    //    enum APIError: Error {
    //        case error(String)
    //
    //        var localizedDescription: String {
    //            switch self {
    //            case .error(let string):
    //                return string
    //
    //            }
    //        }
    //    }
    
    
    
}

