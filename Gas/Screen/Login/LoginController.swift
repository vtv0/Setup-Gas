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


struct GetLatestWorkerRouteLocationList : Decodable {
    //    var
}

//struct Employee: Codable {
//    var userName : String
//    var pass : String
//    var id : String
//
//}

class ViewController: UIViewController, UITextFieldDelegate {
    
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
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "pass")
            UserDefaults.standard.removeObject(forKey: "id")
        } else {
            self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
            
            UserDefaults.standard.set(txtUserName.text, forKey: "userName")
            UserDefaults.standard.set(txtPass.text, forKey: "pass")
            UserDefaults.standard.set(txtId.text, forKey: "id")
            
        }
    }
    
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBAction func btnLogin(_ sender: UITextField) {
        let showUserName = UserDefaults.standard.string(forKey: "userName")
        let showPass = UserDefaults.standard.string(forKey: "pass")
        let showId = UserDefaults.standard.string(forKey: "id")
        print("\(String(describing: showUserName))")
        print("\(String(describing: showPass))")
        print("\(String(describing: showId))")
        
        //        if txtUserName.text!.isEmpty || txtPass.text!.isEmpty || txtId.text!.isEmpty {
        //
        //        }
        
        _ = storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
        postGetToken()
        // post()
        //        self.showActivity()
        //        let delay1 = 3
        //        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay1)) { [self] in
        //            self.hideActivity()
        //            self.navigationController?.pushViewController(mhDeliveryList, animated: true)
        //        }
    }
    
    let url = "https://am-stg-iw01j.kiiapps.com/am/api/oauth2/token"
   
    var urlGetLatestWorkerRouteLocationList = "https://am-stg-iw01j.kiiapps.com/am/exapi/vrp/tenants/"
    var token = UserDefaults.standard.string(forKey: "response") ?? ""
    //    let expiredDate =Calendar.current.date(byAdding: .hour, value: 12, to: Date())!
    
//    let parameters: [String: Any] = ["username": "dev_driver1@dev1.test", "password": "dev123456", "companyCode": "am-stg-iw01j", "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
    
        
    
    
    //    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //    let date: NSDate? = dateFormatterGet.dateFromString("2016-02-29 12:24:26")
    
    var showUserName = UserDefaults.standard.string(forKey: "userName")
    let showPass = UserDefaults.standard.string(forKey: "pass")
    let showId = UserDefaults.standard.string(forKey: "id")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        AF.request("https://am-stg-iw01j.kiiapps.com/am/api/oauth2/token")
//            .response {  response in
//                let status = response.response?.statusCode
//                print("STATUS: \(status)")
//            }
        
        bRec = !bRec
        if (bRec ){
            self.btnSaveAccount.setImage(UIImage(named: "checkmarkEmpty"), for: .normal)
            
        } else {
            self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
            txtUserName.text = showUserName
            txtPass.text = showPass
            txtId.text = showId
        }
        
        if txtUserName.text!.isEmpty || txtPass.text!.isEmpty || txtId.text!.isEmpty {
            print ("nhap TK")
            //                    btnLogin.isEnabled = false
            //                    btnLogin.isUserInteractionEnabled = false
        }
        //else {
        //            btnLogin.isEnabled = true
        //            btnLogin.isUserInteractionEnabled = true
        //        }
        
        let dateFormatterGet = DateFormatter()
        let workDate = dateFormatterGet.string(from: Date())
        
        imgIcon.image = UIImage(named:"icon.jpg")
        
        let usernName = txtUserName.addTarget(self, action:  #selector(self.onInputUserName(_:)), for: .editingChanged)
        txtPass.addTarget(self, action:  #selector(self.onInputPass(_:)), for: .editingChanged)
        txtId.addTarget(self, action:  #selector(self.onInputId(_:)), for: .editingChanged)
        
        let defaults = UserDefaults.standard
        defaults.set(txtUserName.text, forKey: "usernName")
        
        
    }
    @objc func onInputUserName(_ sender: UITextField) {
        print("name", sender.text ?? "")
        txtUserName.text = sender.text ?? ""
    }
    @objc func onInputPass(_ sender: UITextField) {
        print("Pass", sender.text ?? "")
        txtPass.text = sender.text ?? ""
    }
    @objc
    func onInputId(_ sender: UITextField) {
        print("Id", sender.text ?? "")
        txtId.text = sender.text ?? ""
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    //   if let urlError = error.underlyingError as? URLError,   //invalid host sai mk ,tk
    //    urlError.code == .cannotFindHost
    
    
    
    //    func post() {
    //        let request = URLRequest(url: URL(string:"url")!)
    //        AF.request(request).validate(statusCode: 200..<300).responseJSON { (response) in
    //            switch response.result {
    //            case .success(let JSON):
    //
    //                print("OK")
    //
    //                //completion(true,data)
    //            case .failure(let err):
    //                print(err.localizedDescription)
    //                //completion(false,err)
    //            default: break
    //                print("oang")
    //                //completion(false,nil)
    //            }
    //        }
    //
    //    }
    
    
    func showAlert(title: String? = "", message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
    
    func postGetToken() {
        let parameters: [String: Any] = ["username": txtUserName.text!, "password": txtPass.text!, "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
        let url = "https://\(txtId.text!).kiiapps.com/am/api/oauth2/token"
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
            .responseDecodable (of: AccountInfo.self) {  response in
               // print("\(response)")
                switch response.result {
                case .success(_):
                    let token = response.value?.access_token ?? ""
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    self.getMe()
                    
                    
                case .failure(let error):
                    print("Failed with error: \(error)")
                    
                }
            }
        
    }
    
    func getMe() {
        let urlGetMe = "https://\(txtId.text!).kiiapps.com/am/api/me"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token))
            
            .responseDecodable(of: GetMeInfo.self) { response1 in
                
                switch response1.result {
                case .success(let getMeInfo):
                    UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
                    UserDefaults.standard.set(getMeInfo.id, forKey: "userId")
                    
//                    let str = UIStoryboard.init(name: "ViewController", bundle: nil)
//
//                    let vc = UINavigationController(rootViewController: str.instantiateViewController(withIdentifier: "LoginViewController"))
//                    UIApplication.shared.windows.first?.rootViewController = vc
                    
                    print("tenantID: \(getMeInfo.tenants[0].id)")
                case .failure(let error):
                    print("Failed with error: \(error)")
                }
                //print("Token: \(response1.request?.headers)")
                // print("ID: \(response1.value?.id)")
                //                        let id = response1.value?.id
                //                        UserDefaults.standard.set(id, forKey: "userId")
                
            }
    }
}





