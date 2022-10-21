//
//  ViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 26/09/2022.
//

import UIKit
import Alamofire
import Network
import SystemConfiguration


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
    
  //  var viewActivity: ActivityIndicator!
    
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
            UserDefaults.standard.removeObject(forKey: "accessToken")
        } else {
            self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
            
            UserDefaults.standard.set(txtUserName.text, forKey: "userName")
            UserDefaults.standard.set(txtPass.text, forKey: "pass")
            UserDefaults.standard.set(txtcompanyCode.text, forKey: "companyCode")
            UserDefaults.standard.set(token, forKey: "accessToken")
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
        
                if txtUserName.text!.isEmpty || txtPass.text!.isEmpty || txtcompanyCode.text!.isEmpty {
                    self.showAlert(message: "Nhập đầy đủ thông tin tài khoản")
                } else  {
                    self.postGetToken()
                   
                }
        // _ = storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
      //  postGetToken()
       // self.checkConnectInternet()
  //      if (
        
        
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
    
    func saveLoggedState() {

        let def = UserDefaults.standard
        def.set(true, forKey: "is_authenticated") // save true flag to UserDefaults
        def.synchronize()

    }
    
    func isInternetAvailable() -> Bool {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)

            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }

            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            return (isReachable && !needsConnection)
        }

        func showAlertInternet() {
            if !isInternetAvailable() {
                let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
                let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.checkConnectInternet()
        self.isInternetAvailable()
        
        //        monitor.pathUpdateHandler = { pathUpdateHandler in
        //                    if pathUpdateHandler.status == .satisfied {
        //                        print("Internet connection is on.")
        //                    } else {
        //                        print("There's no internet connection.")
        //                    }
        //                }
        //
        //                monitor.start(queue: queue)
    
        navigationItem.hidesBackButton = true
        
//        bRec = !bRec
//        if (bRec ){
//            self.btnSaveAccount.setImage(UIImage(named: "checkmarkEmpty"), for: .normal)
//            
//        } else {
//            self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
//            txtUserName.text = showUserName
//            txtPass.text = showPass
//            txtcompanyCode.text = showcompanyCode
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
//    let monitor = NWPathMonitor(requiredInterfaceType: .cellular)
//    let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
//    let monitor = NWPathMonitor()
//    let queue = DispatchQueue(label: "InternetConnectionMonitor")
//    func checkConnectInternet() {
//        monitor.pathUpdateHandler = {  pathUpdateHandler in
//            if pathUpdateHandler.status == .satisfied {
//                print("Internet connection is on.")
//           //     self.showAlert(message: "ok")
//               // self.postGetToken()
//            } else {
//               // self.showAlert(message: "loi")
//                print("There's no internet connection.")
//            }
//        }
//
//        monitor.start(queue: queue)
//    }
    
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
        //self.checkConnectInternet()
        let parameters: [String: Any] = ["username": txtUserName.text!, "password": txtPass.text!, "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
//   self.showActivity()
        let url = "https://\(txtcompanyCode.text!).kiiapps.com/am/api/oauth2/token"
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of: AccountInfo.self) {  response in
                print("\(String(describing: response.response?.statusCode))")
                switch response.result {
                case .success( _):
                    let token = response.value?.access_token ?? ""
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    self.getMe()
                    
                    
                    if let httpURLResponse = response.response {
                        if(httpURLResponse.statusCode == 200) {
                            let mhDeliveryList = self.storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
                            
                            self.navigationController?.pushViewController(mhDeliveryList, animated: true)
//                            let delay1 = 3
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay1)) { [self] in
//                                self.hideActivity()
//
//                            }
                        }
                    }
                case .failure(let error):
                    //self.showAlertInternet()
                    
              //      self.checkConnectInternet()
                    // self.showAlert(message: "Sai thông tin đăng nhập")
//                    let statusCODE =  response.response?.statusCode
//                    if (statusCODE == nil){
//                        self.showAlert(message: "Lỗi kết nối Internet")
//                        print("statusCODE nil")
//                    }
                   // print("status CODE: \(String(describing: statusCODE))")
        //     self.hideActivity()
                    if (response.response?.statusCode == 403) {
                        self.showAlert(message: "Sai mk (Error: 403)")
                        
//                        } else if (httpURLResponse.statusCode == 401) {
//                            self.showAlert(message: "Token Out of Date")
//                            let passScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
//                            self.navigationController?.pushViewController(passScreen, animated: false)
//                        } else if(httpURLResponse.statusCode == 400)  {
//                            self.showAlert(message: "Nhập thiếu thông tin tài khoản")
//
                        
                    } else if let urlError = error.underlyingError as? URLError , urlError.code == .cannotFindHost {
                        self.showAlert(message: "Sai mật khẩu")
                    } else {
                        self.showAlert(message: "Lỗi xảy ra")
                    }
                }
            }
    }
    
    func getMe() {
        let urlGetMe = "https://\(txtcompanyCode.text!).kiiapps.com/am/api/me"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        print("\(token)")
        
        
        
        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetMeInfo.self) { response1 in
                switch response1.result {
                case .success(let getMeInfo):
                    UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
                    UserDefaults.standard.set(getMeInfo.id, forKey: "userId")
                    print("userID: \(getMeInfo.id)")
                    print("tenantID: \(getMeInfo.tenants[0].id)")
                    
                    //  self.statusCode()
                    // self.statusCode()
                 //   print(" ok dung")
                    //                    let str = UIStoryboard.init(name: "ViewController", bundle: nil)
                    //
                    //                    let vc = UINavigationController(rootViewController: str.instantiateViewController(withIdentifier: "LoginViewController"))
                    //                    UIApplication.shared.windows.first?.rootViewController = vc
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
    
//    func statusCode() {
//        let urlGetMe = "https://\(txtcompanyCode.text!).kiiapps.com/am/api/me"
//        AF.request(urlGetMe)/////////////////////////////////////////////////////////////////
//            .response {  response in
//                let status = response.response?.statusCode
//                print("STATUS: \(String(describing: status))")
//            }
//    }
}





