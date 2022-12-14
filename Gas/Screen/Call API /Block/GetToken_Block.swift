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

var txtUserName = UserDefaults.standard.string(forKey: "userName") ?? ""
var txtPass =  UserDefaults.standard.string(forKey: "pass") ?? ""
var txtcompanyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""

enum FetcherError: Error {
    case invalidURL
    case missingData
}

class PostGetToken {
    let url: String?
    
    init(url: String?) {
        self.url = url
    }
    
    func postGetToken_Block() {
        let parameters: [String: Any] = ["username": txtUserName, "password": txtPass, "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
        let url = "https://\(txtcompanyCode).kiiapps.com/am/api/oauth2/token"
        //        self.showActivity()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: AccountInfo.self) { response in
                switch response.result {
                case .success(_):
                    
                    let token = response.value?.access_token ?? ""
                    
                    if let httpURLResponse = response.response {
                        UserDefaults.standard.set(txtUserName, forKey: "userName")
                        UserDefaults.standard.set(txtPass, forKey: "pass")
                        UserDefaults.standard.set(txtcompanyCode, forKey: "companyCode")
                        UserDefaults.standard.set(token, forKey: "accessToken")
//                        let mhDeliveryList = storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
//                        navigationController?.pushViewController(mhDeliveryList, animated: true)
                    }

                    let getMe = GetMe(url: "")
                    getMe.getMe_Block()

                case .failure(let error):
                    
                    if (response.response?.statusCode == 403) {
//                        showAlert(message: "Sai mk (Error: 403)")
                    } else if let urlError = error.underlyingError as? URLError , urlError.code == .cannotFindHost {
//                        showAlert(message: "Sai m???t kh???u")
                    } else {
//                        showAlert(message: "L???i x???y ra")
                    }
                }
                
            }
    }
}

