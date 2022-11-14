////
////  Extension+APIGetMe.swift
////  Gas
////
////  Created by Vuong The Vu on 11/11/2022.
////
//
//import Foundation
//import UIKit
//extension UIViewController {
//    
//    func  getLatestWorkerRouteLocationList() {
//        var t: Int = 0
//        var totalObjectSevenDate: Int = 0
//        self.showActivity()
//        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        
//        
//        for iday in dateYMD {
//            let dateString: String = formatter.string(from: iday)
//            let url: String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(dateString)"
//            
//            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default ,headers: self.makeHeaders(token: token)).validate(statusCode: (200...299))
//                .responseDecodable(of: GetLatestWorkerRouteLocationListInfo.self) { response in
//                    print("\(url)::::>\( response.response?.statusCode ?? 0)")
//                    
//                    self.t += 1
//                    
//                    switch response.result {
//                    case .success(_):
//                        let countObject = response.value?.locations?.count
//                        self.locations = response.value?.locations ?? []
//                        
//                        
//                        if countObject != 0 {
//                            var locations: [LocationElement] = []
//                            for itemObject in self.locations {
//                                locations.append(itemObject)
//                                
//                                self.totalObjectSevenDate += 1
//                                
//                                
//                                if itemObject.location?.assetID != nil {
//                                    self.getGetAsset(forAsset: (itemObject.location!.assetID)!, locationOrder: itemObject.locationOrder )
//                                    
//                                } else {
//                                    print("Khong co assetID-> Supplier")
//                                }
//                            }
//                            self.dicData[iday] = locations
//                            
//                        } else {
//                            print(response.response?.statusCode as Any)
//                            print("\(url) =>> Array Empty, No Object ")
//                        }
//                        
//                    case .failure(let error):
//                        
//                        print("Error: \(response.response?.statusCode ?? 000000)")
//                        print("Error: \(error)")
//                    }
//                    if self.t == self.dateYMD.count {
//                        self.reDrawMarkers()
//                        self.hideActivity()
//                        
//                    }
//                }
//        }
//        
//    }
//    
//    func getGetAsset(forAsset iassetID: String, locationOrder: Int) {
//        
//        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
//        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
//        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeaders(token: token))
//            .responseDecodable(of: GetAsset.self ) { response1 in
//                switch response1.result {
//                case .success:
//                    if self.totalObjectSevenDate == self.totalObjectSevenDate {
//                        self.hideActivity()
//                    }
//                    
//                case .failure(let error):
//                    print("\(error)")
//                }
//            }
//        
//    }
//
//}
