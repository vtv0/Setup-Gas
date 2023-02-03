//
//  GetMe_Async_Await.swift
//  Gas
//
//  Created by Vuong The Vu on 13/01/2023.
//

import UIKit
import Alamofire

class GetMe_Async_Await {
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    
    
//    enum AFError: Error {
//        case error(String)
//        
//        var localizedDescription: String {
//            switch self {
//            case .error(let ok):
//                return ok
//            }
//            
//        }
//    }

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
    
    
    func getMe_Async_Await() async throws -> [Int] {  //
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
    
    func fetchAPI<T: Decodable>(url: URL) async throws -> T {
        let data = try await URLSession.shared.data(url: url)
        let decodeData = try JSONDecoder().decode(T.self, from: data)
        return decodeData
    }
    
}

extension URLSession {
    func data(url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation({ c in
            dataTask(with: url) { data, _, error in
                if let error = error {
                    c.resume(throwing: APIError.error(error.localizedDescription))
                } else {
                    if let data = data {
                        c.resume(returning: data)
                    } else {
                        c.resume(throwing: APIError.error("Bad response"))
                    }
                }
            }.resume()
        })
    }
    enum APIError: Error {
        case error(String)
        
        var localizedDescription: String {
            switch self {
            case .error(let string):
                return string
                
            }
        }
    }
   
}
