////
////  Extension+APIGetMe.swift
////  Gas
////
////  Created by Vuong The Vu on 11/11/2022.
////
//
import UIKit
import Alamofire


extension UIViewController {
    
    func getMeExtension() {
        self.showActivity()
        
        let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        let urlGetMe = "https://\(showcompanyCode).kiiapps.com/am/api/me"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeadersExtension(token: token))
            .responseDecodable(of: GetMeInfo.self) { response1 in
                switch response1.result {
                case .success(let getMeInfo):
                    UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
                    UserDefaults.standard.set(getMeInfo.id, forKey: "userId")
                    self.getLatestWorkerRouteLocationListExtension()
                case .failure(let error):
                    if response1.response?.statusCode == 401 {
                        let src = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                        self.navigationController?.pushViewController(src, animated: true)
                        break
                    } else {
                        print("Error: \(response1.response?.statusCode ?? 000000)")
                        print("Error: \(error)")
                    }
                }
            }
    }
    
    
    func makeHeadersExtension(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    
    func  getLatestWorkerRouteLocationListExtension() -> Dictionary<Date, [Location]> {
        
        // 7 Date
        var dateYMD: [Date] = []
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                dateYMD.append(date1)
            }
        }
        
        var dicData: [Date : [Location]] = [:]
        let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        var t: Int = 0
        
        // self.showActivity()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        for iday in dateYMD {
            let dateString: String = formatter.string(from: iday)
            let url: String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(dateString)"
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default ,headers: self.makeHeadersExtension(token: token)).validate(statusCode: (200...299))
                .responseDecodable(of: GetLatestWorkerRouteLocationListInfo.self) { response in
                    t += 1
                    switch response.result {
                    case .success(_):
                        let countObject = response.value?.locations?.count
                        let locations1: [LocationElement] = response.value?.locations ?? []
                        if countObject != 0 {
                            var arrLocationValue: [Location] = []
                            for itemObject in locations1 {
                                arrLocationValue.append(Location.init(elem: itemObject, asset: nil))
                            }
                            for iLocationValue in arrLocationValue {
                                if let  assetID = iLocationValue.elem?.location?.assetID {
                                    self.getGetAssetExtension(forAsset: assetID) { iasset in
                                        iLocationValue.asset = iasset
                                    }
                                } else {
                                    print("No assetID -> Supplier")
                                }
                            }
                            dicData[iday] = arrLocationValue
                            
                        } else {
                            print(response.response?.statusCode as Any)
                            print("\(url) =>> Array Empty, No Object ")
                        }
                    case .failure(let error):
                        print("Error: \(response.response?.statusCode ?? 000000)")
                        print("Error: \(error)")
                    }
                    if t == dateYMD.count {
                        //  self.reDrawMarkers()
                        guard let replanVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplanController") as? ReplanController else { return }
                        replanVC.dicData = dicData
                        self.hideActivity()
                    }
                }
        }
        
        return dicData
    }
    
    func getGetAssetExtension(forAsset iassetID: String, completion: @escaping  ((GetAsset?) -> Void)) {
        let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        
        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeadersExtension(token: token))
            .responseDecodable(of: GetAsset.self ) { response1 in
                switch response1.result {
                case .success( let value):
                    
                    
                    completion(value)
                case .failure(let error):
                    print("\(error)")
                    completion(nil)
                }
            }
    }
}




