//
//  GetToken_Block.swift
//  Gas
//
//  Created by Vuong The Vu on 11/01/2023.
//

import UIKit
import Alamofire

struct AccountInfo: Decodable {
    var access_token: String
    var expires_in: Int
    var token_type: String
}

class PostGetToken_Block {
    let url: String? = nil
    
    enum CaseError: Error {
        case ok
        case wrongURL
        case tokenOutOfDate
        case wrongPassword
        case remain
    }
    
    func postGetToken_Block(username: String, pass: String, companyCode: String, completion: @escaping ( ((String?), (CaseError?) ) -> Void)) {
        let parameters: [String: Any] = ["username": username, "password": pass, "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
        let url = "https://\(companyCode).kiiapps.com/am/api/oauth2/token"
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: AccountInfo.self) { response in
                switch response.result {
                    
                case .success(_):
                    print(response.result)
                    let token = response.value?.access_token ?? ""
                    
                    if let _ = response.response {
                        UserDefaults.standard.set(username, forKey: "userName")
                        UserDefaults.standard.set(pass, forKey: "pass")
                        UserDefaults.standard.set(companyCode, forKey: "companyCode")
                        //                        UserDefaults.standard.set(token, forKey: "accessToken")
                        completion(token, PostGetToken_Block.CaseError.ok)
                    }
                case .failure(let error):
                    if (response.response?.statusCode == 403) {  // sai mat khau
                                                                  //  401: han han token

                       // CaseError.wrongPassword
                        completion(nil,CaseError.wrongPassword)
                    } else if let urlError = error.underlyingError as? URLError , urlError.code == .cannotFindHost {
                        completion(nil,CaseError.wrongURL)
                    } else {
                        completion(nil,CaseError.remain)
                    }
                    
                }
            }
    }
    
    
    
}

  // dung closure truyen data -> uiview...
