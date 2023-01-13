//
//  GetToken.swift
//  Gas
//
//  Created by Vuong The Vu on 10/01/2023.
//

import UIKit
import Alamofire

class GetToken_Async_Await {
    
    func getToken_Async_Await(userName: String, pass: String, companyCode: String) async {
        
        let parameters: [String: Any] = ["username": userName, "password": pass, "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
        let url = "https://\(companyCode).kiiapps.com/am/api/oauth2/token"
        

        //        self.showActivity()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: AccountInfo.self) { response in
                switch response.result {
                case .success(_):
                    print(response.result)
                    let token = response.value?.access_token ?? ""
                    
                    if let httpURLResponse = response.response {
                        UserDefaults.standard.set(userName, forKey: "userName")
                        UserDefaults.standard.set(pass, forKey: "pass")
                        UserDefaults.standard.set(companyCode, forKey: "companyCode")
                        UserDefaults.standard.set(token, forKey: "accessToken")
//                        let mhDeliveryList = storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
//                        navigationController?.pushViewController(mhDeliveryList, animated: true)
                    }

                case .failure(let error):
                    
                    if (response.response?.statusCode == 403) {
//                        showAlert(message: "Sai mk (Error: 403)")
                    } else if let urlError = error.underlyingError as? URLError , urlError.code == .cannotFindHost {
//                        showAlert(message: "Sai mật khẩu")
                    } else {
//                        showAlert(message: "Lỗi xảy ra")
                    }
                }
            }
    }
}



