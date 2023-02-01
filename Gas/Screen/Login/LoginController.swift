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
        if (bRec ) { // khong luu
            self.btnSaveAccount.setImage(UIImage(named: "checkmarkEmpty"), for: .normal)
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "pass")
            UserDefaults.standard.removeObject(forKey: "companyCode")
            UserDefaults.standard.removeObject(forKey: "accessToken")
        } else {
            self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBAction func btnLogin(_ sender: UITextField) {
        
        self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
        let db = DB(UserName: "", Pass: "", CompanyCode: "")
        db.companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        db.pass = UserDefaults.standard.string(forKey: "pass") ?? ""               // txtPass.text ?? ""
        db.userName = UserDefaults.standard.string(forKey: "userName") ?? ""       // txtPass.text ?? ""
        if txtUserName.text!.isEmpty || txtPass.text!.isEmpty || txtcompanyCode.text!.isEmpty {
            self.showAlert(message: "Nhập đầy đủ thông tin tài khoản")
        } else {
            showActivity()
            
            //MARK: - Block
            //           callAPI_Block()
            
            
            //MARK: - Use ASYNC AWAIT
            Task {
                await callAPI_Async_Await()
            }
        }
    }
    
    func callAPI_Async_Await() async {
        let parameters: [String: Any] = ["username": txtUserName.text ?? "", "password": txtPass.text ?? "", "expiresAt": Int64(Calendar.current.date(byAdding: .hour, value: 12, to: Date())!.timeIntervalSince1970 * 1000), "grant_type": "password"]
        let url = "https://\(txtcompanyCode.text ?? "").kiiapps.com/am/api/oauth2/token"
        let postGetToken = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).serializingDecodable(AccountInfo.self)
       
        let getTokenResponse = await postGetToken.response
        let token = getTokenResponse.value?.access_token ?? ""
        UserDefaults.standard.set(token, forKey: "accessToken")
//        print(getTokenResponse.response?.statusCode)
        switch getTokenResponse.result {
        case .success(let value):
            print(value)
            
            
        case .failure(let error):
            print(error)
        }
        
        
        
        let urlGetMe = "https://\(txtcompanyCode.text ?? "").kiiapps.com/am/api/me"
        let getMe = AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token)).serializingDecodable(GetMeInfo.self)
        let getMeResponse = await getMe.response
        
        switch getMeResponse.result {
        case .success(_):
            UserDefaults.standard.set(txtcompanyCode.text, forKey: "companyCode")
            let userId = getMeResponse.value?.id
            let tenantId = getMeResponse.value?.tenants[0].id
            UserDefaults.standard.set(tenantId, forKey: "tenantId")
            UserDefaults.standard.set(userId, forKey: "userId")
            
            let mhDeliveryList = self.storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
            self.navigationController?.pushViewController(mhDeliveryList, animated: true)
            
        case .failure(let error):
            print(error)
        }
        
        enum CaseError: String {
            case outOfDate
        }
        
    }
    
    func callAPI_Block() {
        //       let dispatchGroup = DispatchGroup()
        PostGetToken_Block().postGetToken_Block(username: txtUserName.text!, pass: txtPass.text!, companyCode: txtcompanyCode.text!) { [self] token, error  in
            if token != nil {
                UserDefaults.standard.set(token, forKey: "accessToken")
                GetMe_Block().getMe_Block(commpanyCode: self.txtcompanyCode.text!, acccessToken: token ?? "") { (dataID, detailError) in
                    if !dataID.isEmpty {
                        UserDefaults.standard.set(dataID[0], forKey: "tenantId")
                        UserDefaults.standard.set(dataID[1], forKey: "userId")
                        let mhDeliveryList = self.storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
                        self.navigationController?.pushViewController(mhDeliveryList, animated: true)
                        self.hideActivity()
                    }
                }
            } else if token == nil {
                let err = error
                switch err {
                case .wrongPassword:
                    showAlert(message: "Sai thông tin tài khoản")
                    hideActivity()
                case .ok: break
                case .tokenOutOfDate:
                    let mhLogin = self.storyboard?.instantiateViewController(identifier:  "LoginViewController") as! ViewController
                    self.navigationController?.pushViewController(mhLogin, animated: true)
                    hideActivity()
                case .remain:
                    showAlert(message: "Có lỗi xảy ra")
                    hideActivity()
                case .none:
                    break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        let showUserName = UserDefaults.standard.string(forKey: "userName") ?? ""           //"dev_driver1@dev2.test"
        let showPass = UserDefaults.standard.string(forKey: "pass") ?? ""                   // "dev123456"
        let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""     // "am-stg-iw01j"
        
        if !showUserName.isEmpty {
            btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
            txtUserName.text = showUserName
            txtPass.text = showPass
            txtcompanyCode.text = showcompanyCode
            
        } else {
            btnSaveAccount.setImage(UIImage(named: "checkmarkEmpty"), for: .normal)
        }
        
        imgIcon.image = UIImage(named:"Icon-1024")
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
    
}





