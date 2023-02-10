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
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    
    enum CaseError: Error {
        case ok
        case tokenOutOfDate
        case wrongPassword
        case remain
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func getMe_Block(commpanyCode: String, acccessToken: String, completion: @escaping ([Int],(CaseError)) -> Void ) {
        let urlGetMe = "https://\(companyCode).kiiapps.com/am/api/me"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
      
        var arrID = [Int]()
        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetMeInfo.self) { response1 in
                switch response1.result {
                case .success(let getMeInfo):
                    
                    let tenantId = getMeInfo.tenants[0].id
                    let userId = getMeInfo.id
                    arrID.append(tenantId)
                    arrID.append(userId)
                  //  UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
                  //  UserDefaults.standard.set(self.companyCode, forKey: "userId")
                    completion(arrID, GetMe_Block.CaseError.ok)
                    
                case .failure(let detailError):
                    print("Failed with error: \(detailError)")
                    completion([], GetMe_Block.CaseError.remain)
                }
            }
        
    }
    
    

    
}




