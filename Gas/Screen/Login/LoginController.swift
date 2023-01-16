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
    let showPass = UserDefaults.standard.string(forKey: "pass") ?? ""
    let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    
    
    
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
            //            UserDefaults.standard.removeObject(forKey: "userName")
            //            UserDefaults.standard.removeObject(forKey: "pass")
            //            UserDefaults.standard.removeObject(forKey: "companyCode")
            //            UserDefaults.standard.removeObject(forKey: "accessToken")
        } else {
            self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
            //            let db = DB(UserName: txtcompanyCode.text ?? "", Pass: txtPass.text ?? "", CompanyCode: txtcompanyCode.text ?? "")
            //            db.companyCode = txtcompanyCode.text ?? ""
            //            db.pass = txtPass.text ?? ""
            //            db.userName = txtPass.text ?? ""
            
            UserDefaults.standard.set(txtUserName.text, forKey: "userName")
            UserDefaults.standard.set(txtPass.text, forKey: "pass")
            UserDefaults.standard.set(txtcompanyCode.text, forKey: "companyCode")
            
            //      UserDefaults.standard.set(token, forKey: "accessToken")
        }
    }
    
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBAction func btnLogin(_ sender: UITextField) {
       
        //        UserDefaults.standard.set(txtUserName.text, forKey: "userName")
        //        UserDefaults.standard.set(txtPass.text, forKey: "pass")
        //        UserDefaults.standard.set(txtcompanyCode.text, forKey: "companyCode")
        
        //        let showUserName = UserDefaults.standard.string(forKey: "userName") ?? ""
        //        let showPass = UserDefaults.standard.string(forKey: "pass") ?? ""
        //        let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        
        self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
        let db = DB(UserName: "", Pass: "", CompanyCode: "")
        db.companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        db.pass = UserDefaults.standard.string(forKey: "pass") ?? ""               // txtPass.text ?? ""
        db.userName = UserDefaults.standard.string(forKey: "userName") ?? ""       // txtPass.text ?? ""
        if txtUserName.text!.isEmpty || txtPass.text!.isEmpty || txtcompanyCode.text!.isEmpty {
            self.showAlert(message: "Nhập đầy đủ thông tin tài khoản")
        } else {
            
            
            //MARK: - Block
            PostGetToken_Block().postGetToken_Block(info: txtUserName.text!, pass: txtPass.text!, companyCode: txtcompanyCode.text!) { token in

                GetMe_Block().getMe_Block(info: self.txtcompanyCode.text!, acccessToken: token ?? "") { data in
                    print(data)
                    if data != nil {
                        
                        let mhDeliveryList = self.storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
                        self.navigationController?.pushViewController(mhDeliveryList, animated: true)
                    }

                }
                
            }
            
            
            //MARK: -
            // Use ASYNC AWAIT
//            Task {
//                await callApi_Async_Await()
//                
//                
//            }
        }
    }
    
    func callApi_Async_Await() async {
        
        let getToken = GetToken_Async_Await()
        await getToken.getToken_Async_Await(userName: txtUserName.text ?? "", pass: txtPass.text ?? "", companyCode: txtcompanyCode.text ?? "")
        let getMe = GetMe_Async_Await()
//        await getMe.getMe_Async_Await(completion: () -> Void)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        if !showUserName.isEmpty {
            btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
        }
        if (bRec) {
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
    
    
    
    enum FetcherError: Error {
        case invalidURL
        case missingData
    }
    
}





