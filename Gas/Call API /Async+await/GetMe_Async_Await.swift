//
//  GetMe_Async_Await.swift
//  Gas
//
//  Created by Vuong The Vu on 13/01/2023.
//

import UIKit
import Alamofire

class GetMe_Async_Await {

    enum AFError: Error {
        case tokenOutOfDate
        case wrongPassword
        case remain
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    
    func getMe_Async_Await(companyCode: String, token: String) async throws -> [Int] {
        var arrId: [Int] = []
        let urlGetMe = "https://\(companyCode).kiiapps.com/am/api/me"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        let getMe = AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token)).serializingDecodable(GetMeInfo.self)
        let getMeResponse = await getMe.response
        
        switch getMeResponse.result {
        case .success(_):
            UserDefaults.standard.set(companyCode, forKey: "companyCode")
            let userId = getMeResponse.value?.id ?? 0
            let tenantId = getMeResponse.value?.tenants[0].id ?? 0
            UserDefaults.standard.set(tenantId, forKey: "tenantId")
            UserDefaults.standard.set(userId, forKey: "userId")
            arrId.append(tenantId)
            arrId.append(userId)
            
        case .failure(_):
            if getMeResponse.response?.statusCode == 401 {
                throw AFError.tokenOutOfDate
            } else {
                throw AFError.remain
            }
        }
        return arrId
    }
    
}


