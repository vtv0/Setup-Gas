//
//  ViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 26/09/2022.
//

import UIKit
import Alamofire
struct AccountInfo: Decodable {
    var access_token: String
    var expires_in: Int
    var token_type: String
}
struct GetMeInfo: Decodable {
    var id: Int
    var tenants: [Tenant]
    //    var workerDate: Date
    
}
struct  Tenant: Decodable {
    var admin: Bool
    var id: Int
    var roleName: String
}

class ViewController: UIViewController, UITextFieldDelegate{
    
    
    
    
    var viewActivity: ActivityIndicator!
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtId: UITextField!
    
    
    var bRec:Bool = true
    @IBOutlet weak var btnSaveAccount: UIButton!
    @IBAction func btnSaveAccount(_ sender: Any) {
        bRec = !bRec
        if (bRec ){
            self.btnSaveAccount.setImage(UIImage(named: "checkmarkEmpty"), for: .normal)
        } else {
            self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
            print("\(txtUserName.text)")
        }
    }
    @IBAction func btnLogin(_ sender: Any) {
        // let mhDeliveryList = storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
        postGetToken()
        //   self.showActivity()
        //        let delay1 = 3
        //        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay1)) { [self] in
        //            self.hideActivity()
        //            self.navigationController?.pushViewController(mhDeliveryList, animated: true)
        //        }
    }
    
    let url = "https://am-stg-iw01j.kiiapps.com/am/api/oauth2/token"
    let urlGetMe = "https://am-stg-iw01j.kiiapps.com/am/api/me"
    var token = UserDefaults.standard.string(forKey: "response") ?? ""
    //    let expiredDate =Calendar.current.date(byAdding: .hour, value: 12, to: Date())!
    let parameters: [String: Any] = ["username": "dev_driver1@dev1.test", "password" : "dev123456", "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPass.delegate = self
        imgIcon.image = UIImage(named:"icon.jpg")
         txtUserName.addTarget(self, action:  #selector(self.onInputUserName(_:)), for: .editingChanged)
        let txtPass = txtPass.addTarget(self, action:  #selector(self.onInputPass(_:)), for: .editingChanged)
        let txtId = txtId.addTarget(self, action:  #selector(self.onInputId(_:)), for: .editingChanged)
        
        
        //        let defaults = UserDefaults.standard
        //        defaults.set("Some String Value", forKey: DefaultsKeys.keyOne)
        //        defaults.set("Another String Value", forKey: DefaultsKeys.keyTwo)
        //
        //       // let defaults = UserDefaults.standard
        //        if let stringOne = defaults.string(forKey: DefaultsKeys.keyOne) {
        //            print(stringOne) // Some String Value
        //        }
        //        if let stringTwo = defaults.string(forKey: DefaultsKeys.keyTwo) {
        //            print(stringTwo) // Another String Value
        //        }
        
        
        
    }
    @objc func onInputUserName(_ sender: UITextField) {
        print("name", sender.text ?? "")
        txtUserName.text = sender.text ?? ""
    }
    @objc func onInputPass(_ sender: UITextField) {
        print("Pass", sender.text ?? "")
        txtPass.text = sender.text ?? ""
    }
    @objc func onInputId(_ sender: UITextField) {
        print("Id", sender.text ?? "")
        txtPass.text = sender.text ?? ""

    }
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func postGetToken() {
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of: AccountInfo.self) {  response in
                // if res {
                // print("aaa\(response.value?.access_token ?? "")")
                
                let token = response.value?.access_token ?? ""
                UserDefaults.standard.set(token, forKey: "accessToken")
                // UserDefaults.standard.set(
                // let headers: HTTPHeaders = [.authorization(bearerToken: token)]
                
                //  }else {
                
                //}
                
                AF.request(self.urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token))
                //                                .responseJSON { response1 in
                //                                    switch response1.result{
                //                                    case .success(let json):
                //                                        print("aaa", json)
                //                                    case .failure(let error):
                //                                        print("bbb", error)
                //                                    }
                //                                }
                    .responseDecodable(of: GetMeInfo.self) { response1 in
                       // print("bbb \(response1.request?.headers)")
                       // print("ccc \(response1.value?.tenants)")
                        let id = response1.value?.id
                        UserDefaults.standard.set(id, forKey: "userId")
                        
                       // let tenant = [id :Int  admin: Bool; roleName: String  ]
                       // let tenants: [Tenant] = response1.
//                        if !tenants.isEmpty {
//                            UserDefaults.standard.set(tenants, forKey: "tenantId")
//                        } else {
//                            print("Tenant empty")
//                        }
                        
                    }
                
                
                //                jsonData.data.forEach {
                //
                //                    print("\(jsonData)")
                //
                //                }
                print("00000", UserDefaults.standard.string(forKey: "accessToken")!)
               // print("11111" , UserDefaults.standard.string(forKey: "tenantId")!)
            }
    }
}



