//
//  GetMe_Async_Await.swift
//  Gas
//
//  Created by Vuong The Vu on 13/01/2023.
//

import UIKit
import Alamofire

class GetMe_Async_Await {
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    
    func getMe_Async_Await() async {
        let urlGetMe = "https://\(UserDefaults.standard.string(forKey: "companyCode") ?? "").kiiapps.com/am/api/me"
         let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        //        self.showActivity()
        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetMeInfo.self) { response1 in
                switch response1.result {
                case .success(let getMeInfo):
                    
                    //  print(getMeInfo)
                    // UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
                    //  UserDefaults.standard.set(getMeInfo.id, forKey: "userId")
                     print("userID: \(getMeInfo.id)")
                     print("tenantID: \(getMeInfo.tenants[0].id)")
                    
//                    let getWorkerList = GetWorkerRouteLocationList_Block(url: "")
//                    getWorkerList.getWorkerRouteLocationList_Block(info: getMeInfo.tenants[0].id, id: getMeInfo.id) { asset in
//
//                    }
                    
                case .failure(let error):
                    print("Failed with error: \(error)")
                    //                    self.showAlert(message:"lỗi xảy ra")
                    
                }
            }
        //        self.hideActivity()
    }
}
