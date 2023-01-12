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


class ViewController: UIViewController, UITextFieldDelegate {
    
    let showUserName = UserDefaults.standard.string(forKey: "userName") ?? ""
    let showPass = UserDefaults.standard.string(forKey: "pass")
    let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode")
    var token = UserDefaults.standard.string(forKey: "response") ?? ""
    let expiredDate = Calendar.current.date(byAdding: .hour, value: 12, to: Date())!
    var dicData: [Date: [Location]] = [:]
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtcompanyCode: UITextField!
    
    var bRec: Bool = true
    @IBOutlet weak var btnSaveAccount: UIButton!
    @IBAction func btnSaveAccount(_ sender: Any) {
        bRec = !bRec
        if (bRec ){ // khong luu
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
//        let showUserName = UserDefaults.standard.string(forKey: "userName")
//        let showPass = UserDefaults.standard.string(forKey: "pass")
//        let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode")

        if txtUserName.text!.isEmpty || txtPass.text!.isEmpty || txtcompanyCode.text!.isEmpty {
            self.showAlert(message: "Nhập đầy đủ thông tin tài khoản")
        } else  {
//            self.postGetToken()
            let postGetToken = PostGetToken(url: "")
            postGetToken.postGetToken_Block()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        if !showUserName.isEmpty {
            btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
        }
        if (bRec){
            txtUserName.text = showUserName
            txtPass.text = showPass
            txtcompanyCode.text = showcompanyCode
            imgIcon.image = UIImage(named:"Icon-1024")
        }
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
        print("companyCode", sender.text ?? "")
        txtcompanyCode.text = sender.text ?? ""
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
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
        self.showActivity()
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of: AccountInfo.self) {  response in
                print("\(String(describing: response.response?.statusCode))")
                switch response.result {
                case .success(_):
                    
                    let token = response.value?.access_token ?? ""
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    
                    self.getMe()
                    if let httpURLResponse = response.response {
                        print(httpURLResponse)
                        UserDefaults.standard.set(self.txtUserName.text, forKey: "userName")
                        UserDefaults.standard.set(self.txtPass.text, forKey: "pass")
                        UserDefaults.standard.set(self.txtcompanyCode.text, forKey: "companyCode")
                        UserDefaults.standard.set(token, forKey: "accessToken")
                        let mhDeliveryList = self.storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
                        self.navigationController?.pushViewController(mhDeliveryList, animated: true)
                    }
                case .failure(let error):
                    
                    if (response.response?.statusCode == 403) {
                        self.showAlert(message: "Sai mk (Error: 403)")
                    } else if let urlError = error.underlyingError as? URLError , urlError.code == .cannotFindHost {
                        self.showAlert(message: "Sai mật khẩu")
                    } else {
                        self.showAlert(message: "Lỗi xảy ra")
                    }
                }
                self.hideActivity()
            }
    }
    
    
    enum FetcherError: Error {
            case invalidURL
            case missingData
        }
    
//    func postGetToken1() async -> String {
//        let parameters: [String: Any] = ["username": txtUserName.text!, "password": txtPass.text!, "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password" ]
//
//        guard let url = URL(string: "https://\(txtcompanyCode.text!).kiiapps.com/am/api/oauth2/token" ) else {
//            throw FetcherError.invalidURL
//        }
//
//        self.showActivity()
//
//        let (data, _) = try await URLSession.shared.dataTask(with: request)
//        return try JSONDecoder().decode(String, from: data)
//
//
//        return ""
//    }
    
    
    
    func getMe() {
        let urlGetMe = "https://\(txtcompanyCode.text!).kiiapps.com/am/api/me"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        print("\(token)")
        self.showActivity()
        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetMeInfo.self) { response1 in
                switch response1.result {
                case .success(let getMeInfo):
                    
                    UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
                    UserDefaults.standard.set(getMeInfo.id, forKey: "userId")
                    print("userID: \(getMeInfo.id)")
                    print("tenantID: \(getMeInfo.tenants[0].id)")
                    
                case .failure(let error):
                    
                    print("Failed with error: \(error)")
                    self.showAlert(message:"lỗi xảy ra")
                    
                }
            }
        self.hideActivity()
    }
    
}





