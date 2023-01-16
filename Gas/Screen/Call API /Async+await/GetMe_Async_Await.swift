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
    
    
    func getMe_Async_Await() async throws {  // -> String 
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
                    let userID = getMeInfo.id
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
//        return userId
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
