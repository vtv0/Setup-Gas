////
////  GetToken_Block.swift
////  Gas
////
////  Created by Vuong The Vu on 11/01/2023.
////
//
//import UIKit
//import Alamofire
//
//
//class postGetToken {
//
//    var urlComponents = URLComponents(string: "http://this/is/the/url")
//    urlComponents?.queryItems = [
//        URLQueryItem(name: "grant_type", value: "password"),
//        URLQueryItem(name: "username", value: "username"),
//        URLQueryItem(name: "password", value: "somepassword")
//    ]
//
//    guard let url = urlComponents?.url else { return }
//    print(url)// You can print url here to see how it looks
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    request.setValue("application/json", forHTTPHeaderField: "Accept")
//    request.setValue("en_US", forHTTPHeaderField: "Accept-Language")
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        guard let data = data,
//              let response = response as? HTTPURLResponse,
//              error == nil else {
//            print("error", error ?? "Unknown error")
//            return
//        }
//        print(response)
//        guard (200 ... 299) ~= response.statusCode else {
//            print("response = \(response)")
//            return
//        }
//
//        let responseString = String(data: data, encoding: .utf8)
//        print(responseString)
//    }
//    task.resume()
//}
//
//var txtUserName =
//var txtPass =
//var txtcompanyCode =
//
//func showAlert(title: String? = "", message: String?, completion: (() -> Void)? = nil) {
//    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//    alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { _ in
//        completion?()
//    }))
//    present(alert, animated: true)
//}
//
//func postGetToken() {
//    let parameters: [String: Any] = ["username": txtUserName.text!, "password": txtPass.text!, "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
//
//    let url = "https://\(txtcompanyCode.text!).kiiapps.com/am/api/oauth2/token"
//
//
//    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        .responseDecodable (of: AccountInfo.self) {  response in
//            print("\(String(describing: response.response?.statusCode))")
//            switch response.result {
//            case .success(_):
//
//                let token = response.value?.access_token ?? ""
//                UserDefaults.standard.set(token, forKey: "accessToken")
//
//                getMe()
//                if let httpURLResponse = response.response {
//                    UserDefaults.standard.set(txtUserName.text, forKey: "userName")
//                    UserDefaults.standard.set(txtPass.text, forKey: "pass")
//                    UserDefaults.standard.set(txtcompanyCode.text, forKey: "companyCode")
//                    UserDefaults.standard.set(token, forKey: "accessToken")
//                    let mhDeliveryList = storyboard?.instantiateViewController(identifier: "DeliveryListController") as! DeliveryListController
//                    navigationController?.pushViewController(mhDeliveryList, animated: true)
//                }
//            case .failure(let error):
//
//                if (response.response?.statusCode == 403) {
//                    showAlert(message: "Sai mk (Error: 403)")
//                } else if let urlError = error.underlyingError as? URLError , urlError.code == .cannotFindHost {
//                    showAlert(message: "Sai mật khẩu")
//                } else {
//                    showAlert(message: "Lỗi xảy ra")
//                }
//            }
//        }
//}
//
//
