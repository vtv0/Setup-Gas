//
//  GetToken.swift
//  Gas
//
//  Created by Vuong The Vu on 10/01/2023.
//

import UIKit
import Alamofire
import AlamofireImage

class PostGetToken_Async_Await {
    
    enum CaseError: String {
        case ok
        case tokenOutOfDate
        case wrongPassword
        case remain
    }
    
    func getToken_Async_Await(userName: String, pass: String, companyCode: String) async {
        

        let parameters: [String: Any] = ["username": userName, "password": pass, "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
        let url = "https://\(companyCode).kiiapps.com/am/api/oauth2/token"
        async let dataTask = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).serializingDecodable(AccountInfo.self)


        
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
//            .responseDecodable(of: AccountInfo.self) { response in
//                switch response.result {
//
//                case .success(_):
//                     token = response.value?.access_token ?? ""
//                   // print(token)
//                    if let _ = response.response {
//                        UserDefaults.standard.set(userName, forKey: "userName")
//                        UserDefaults.standard.set(pass, forKey: "pass")
//                        UserDefaults.standard.set(companyCode, forKey: "companyCode")
//                        UserDefaults.standard.set(token, forKey: "accessToken")
//                    }
//                case .failure(let error):
//                    if (response.response?.statusCode == 403) {
////                        showAlert(message: "Sai mk (Error: 403)")
//                    } else if let urlError = error.underlyingError as? URLError , urlError.code == .cannotFindHost {
////                        showAlert(message: "Sai mật khẩu")
//                    } else {
////                        showAlert(message: "Lỗi xảy ra")
//                    }
//                }
//            }
        
    }
    
}



