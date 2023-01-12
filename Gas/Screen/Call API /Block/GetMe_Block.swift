//
//  GetMe_Block.swift
//  Gas
//
//  Created by Vuong The Vu on 12/01/2023.
//

import UIKit
import Alamofire

struct GetMeInfo: Decodable {
    var id: Int
    var tenants: [Tenant]
}
struct Tenant: Decodable {
    var admin: Bool
    var id: Int
    var roleName: String
}



class GetMe {
    let url: String?
    
    init(url: String?) {
        self.url = url
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func getMe_Block() {
        let urlGetMe = "https://\(txtcompanyCode).kiiapps.com/am/api/me"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        print("\(token)")
//        self.showActivity()
        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetMeInfo.self) { response1 in
                switch response1.result {
                case .success(let getMeInfo):
                    print(getMeInfo)
                    UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
                    UserDefaults.standard.set(getMeInfo.id, forKey: "userId")
                    print("userID: \(getMeInfo.id)")
                    print("tenantID: \(getMeInfo.tenants[0].id)")
                    
                    let getWorkerList = GetWorkerRouteLocationList(url: "")
                    getWorkerList.getLatestWorkerRouteLocationList_Block()
                    
                case .failure(let error):
                    print("Failed with error: \(error)")
//                    self.showAlert(message:"lỗi xảy ra")
                    
                }
            }
//        self.hideActivity()
    }
}

    
    
    
