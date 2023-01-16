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

class GetMe_Block {
    let url: String? = nil
//    var id: String
//    var userID: String
//    typealias CompletionHandler = (_ success: Bool) -> Void
    
//    init(url: String?, id: String, userID: String) {
//        self.url = url
//        self.id = id
//        self.userID = userID
//    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func getMe_Block(info companyCode: String, acccessToken: String, completion: @escaping ([Int]) -> Void ) {
        let urlGetMe = "https://\(companyCode).kiiapps.com/am/api/me"
        let flag = true
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        var arrID = [Int]()
        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: acccessToken))
            .responseDecodable(of: GetMeInfo.self) { response1 -> Void in
                switch response1.result {
                case .success(let getMeInfo):
                    let tenantId = getMeInfo.tenants[0].id
                    let userId = getMeInfo.id
                    arrID.append(tenantId)
                    arrID.append(userId)
                    //  UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
                      UserDefaults.standard.set(companyCode, forKey: "userId")
                    completion(arrID)
                    
                case .failure(let error):
                    print("Failed with error: \(error)")
                    // self.showAlert(message:"lỗi xảy ra")
                    completion([])
                }
            }
        // self.hideActivity()
        
    }
}




