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
    @IBOutlet weak var txtcompanyCode: UITextField!
    
    
    var bRec:Bool = true
    @IBOutlet weak var btnSaveAccount: UIButton!
    @IBAction func btnSaveAccount(_ sender: Any) {
        bRec = !bRec
        if (bRec ){
            self.btnSaveAccount.setImage(UIImage(named: "checkmarkEmpty"), for: .normal)
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "pass")
            UserDefaults.standard.removeObject(forKey: "companyCode")
        } else {
            self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
            
            UserDefaults.standard.set(txtUserName.text, forKey: "userName")
            UserDefaults.standard.set(txtPass.text, forKey: "pass")
            UserDefaults.standard.set(txtcompanyCode.text, forKey: "companyCode")
            
        }
    }
    
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBAction func btnLogin(_ sender: UITextField) {
        let showUserName = UserDefaults.standard.string(forKey: "userName")
        let showPass = UserDefaults.standard.string(forKey: "pass")
        let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode")
        print("\(String(describing: showUserName))")
        print("\(String(describing: showPass))")
        print("\(String(describing: showcompanyCode))")
        
        //        if txtUserName.text!.isEmpty || txtPass.text!.isEmpty || txtId.text!.isEmpty {
        //
        //        }
        
        // _ = storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
        postGetToken()
        
        //self.showActivity()
        //        let delay1 = 3
        //        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay1)) { [self] in
        //            self.hideActivity()
        //            //            self.navigationController?.pushViewController(mhDeliveryList, animated: true)
        //        }
    }
    
    //  let url = "https://am-stg-iw01j.kiiapps.com/am/api/oauth2/token"
    
    //  var urlGetLatestWorkerRouteLocationList = "https://am-stg-iw01j.kiiapps.com/am/exapi/vrp/tenants/"
    var token = UserDefaults.standard.string(forKey: "response") ?? ""
    let expiredDate = Calendar.current.date(byAdding: .hour, value: 12, to: Date())!
    
    //    let parameters: [String: Any] = ["username": "dev_driver1@dev1.test", "password": "dev123456", "companyCode": "am-stg-iw01j", "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
    
    
    
    
    // dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
    // let date: NSDate? = dateFormatterGet.dateFromString("2016-02-29 12:24:26")
    
    var showUserName = UserDefaults.standard.string(forKey: "userName")
    let showPass = UserDefaults.standard.string(forKey: "pass")
    let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        bRec = !bRec
        if (bRec ){
            self.btnSaveAccount.setImage(UIImage(named: "checkmarkEmpty"), for: .normal)
            
        } else {
            self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
            txtUserName.text = showUserName
            txtPass.text = showPass
            txtcompanyCode.text = showcompanyCode
        }
        
        if txtUserName.text!.isEmpty || txtPass.text!.isEmpty || txtcompanyCode.text!.isEmpty {
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
        
        let userName = txtUserName.addTarget(self, action:  #selector(self.onInputUserName(_:)), for: .editingChanged)
        txtPass.addTarget(self, action:  #selector(self.onInputPass(_:)), for: .editingChanged)
        txtcompanyCode.addTarget(self, action:  #selector(self.onInputId(_:)), for: .editingChanged)
        
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
        print("companyCode", sender.text ?? "")
        txtcompanyCode.text = sender.text ?? ""
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
        
        let url = "https://\(txtcompanyCode.text!).kiiapps.com/am/api/oauth2/token"
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
            .responseDecodable (of: AccountInfo.self) {  response in
                // print("\(response)")
                switch response.result {
                case .success( _):
                    let token = response.value?.access_token ?? ""
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    
                    self.getMe()
                case .failure(let error):
                    self.showAlert(message: "Sai thông tin đăng nhập")
                    self.hideActivity()
                    print("Failed with error: \(error)")
                }
            }
    }
    
    func getMe() {
        let urlGetMe = "https://\(txtcompanyCode.text!).kiiapps.com/am/api/me"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        print("\(token)")
        
        //hroDyoJlR8Ok5fzZNEWbrOez3KYGZL22
        
        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetMeInfo.self) { response1 in
                switch response1.result {
                case .success(let getMeInfo):
                    UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
                    UserDefaults.standard.set(getMeInfo.id, forKey: "userId")
                    print("userID: \(getMeInfo.id)")
                    print("tenantID: \(getMeInfo.tenants[0].id)")
                    
                    self.statusCode()
                    // self.statusCode()
                    print(" ok dung")
                    //                    let str = UIStoryboard.init(name: "ViewController", bundle: nil)
                    //
                    //                    let vc = UINavigationController(rootViewController: str.instantiateViewController(withIdentifier: "LoginViewController"))
                    //                    UIApplication.shared.windows.first?.rootViewController = vc
                    if let httpURLResponse = response1.response {
                        if httpURLResponse.statusCode == 200 {
                            let mhDeliveryList = self.storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
                            self.showActivity()
                            let delay1 = 3
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay1)) { [self] in
                                self.hideActivity()
                                self.navigationController?.pushViewController(mhDeliveryList, animated: true)
                            }
                            
                        } else if (httpURLResponse.statusCode == 403) {
                            self.showAlert(message: "Error 403")
                        } else if (httpURLResponse.statusCode == 401) {
                            self.showAlert(message: "Token Out of Date")
                            let passScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                            self.navigationController?.pushViewController(passScreen, animated: false)
                        } else {
                            self.showAlert(message: "Có lỗi xảy ra")
                        }
                    }
                case .failure(let error):
                    print("Failed with error: \(error)")
                    self.showAlert(message:"lỗi xảy ra")
                }
                //print("Token: \(response1.request?.headers)")
                // print("ID: \(response1.value?.id)")
                //                        let id = response1.value?.id
                //                        UserDefaults.standard.set(id, forKey: "userId")
                
            }
    }
    
    func statusCode() {
        let urlGetMe = "https://\(txtcompanyCode.text!).kiiapps.com/am/api/me"
        AF.request(urlGetMe)/////////////////////////////////////////////////////////////////
            .response {  response in
                let status = response.response?.statusCode
                print("STATUS: \(String(describing: status))")
            }
    }
}





