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



let db = DB(UserName: "", Pass: "", CompanyCode: "")
var txtUserName = db.userName
var txtPass =  db.pass
var txtcompanyCode = db.companyCode


enum FetcherError: Error {
    case invalidURL
    case missingData
}

class PostGetToken_Block {
    let url: String? = nil
    
    func postGetToken_Block(info username: String, pass: String, companyCode: String, completion: @escaping ((_ token1: String?) -> Void)) {
      
        let parameters: [String: Any] = ["username": username, "password": pass, "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
        let url = "https://\(companyCode).kiiapps.com/am/api/oauth2/token"
        

        //        self.showActivity()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: AccountInfo.self) { response in  // -> UIViewController
                switch response.result {
                case .success(_):
                    print(response.result)
                    let token = response.value?.access_token ?? ""
//                    let token = token1
                    
                    if let httpURLResponse = response.response {
                        UserDefaults.standard.set(txtUserName, forKey: "userName")
                        UserDefaults.standard.set(txtPass, forKey: "pass")
                        UserDefaults.standard.set(txtcompanyCode, forKey: "companyCode")
//                        UserDefaults.standard.set(token, forKey: "accessToken")
                        
                        completion(token)
                    }


                case .failure(let error):
                    if (response.response?.statusCode == 403) {
//                        showAlert(message: "Sai mk (Error: 403)")
                    } else if let urlError = error.underlyingError as? URLError , urlError.code == .cannotFindHost {
//                        showAlert(message: "Sai mật khẩu")
                    } else {
//                        showAlert(message: "Lỗi xảy ra")
                    }
                    completion(nil)
                }
            }
    }
    
    
    
    
}

  // dung closure truyen data -> uiview...
