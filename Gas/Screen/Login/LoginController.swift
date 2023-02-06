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
        do {
            let getTokenResponse = try await PostGetToken_Async_Await().getToken_Async_Await(userName: txtUserName.text!, pass: txtPass.text!, companyCode: txtcompanyCode.text!)
            print(getTokenResponse)
            
            do {
                let responseGetMe = try await GetMe_Async_Await().getMe_Async_Await()
                print(responseGetMe)
                let deliveryListVC = storyboard?.instantiateViewController(withIdentifier: "DeliveryListController") as! DeliveryListController
                self.navigationController?.pushViewController(deliveryListVC, animated: true)
            } catch {
                if let err = error as? GetMe_Async_Await.AFError {
                    if err == .tokenOutOfDate {
                        showAlert(message: "Token đã hết hạn 1111")
                        let mhLogin = self.storyboard?.instantiateViewController(identifier:  "LoginViewController") as! ViewController
                        self.navigationController?.pushViewController(mhLogin, animated: true)
                        hideActivity()

                    } else if err == .remain {
                        showAlert(message: "Có lỗi xảy ra")
                        hideActivity()
                    }
                }
            }
        } catch {
            if let err = error as? PostGetToken_Async_Await.AFError {
                if err == .wrongURL {
                    showAlert(message: "Sai companyCode")
                    hideActivity()
                } else if err == .wrongPassword {
                    showAlert(message: "Sai password")
                    hideActivity()
                } else if err == .remain {
                    showAlert(message: "Có lỗi xảy ra")
                    hideActivity()
                }
            }
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
                case .some(.wrongURL):
                    showAlert(message: "Sai thông tin tài khoản")
                    hideActivity()
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
        
        //        Task {
        //            await aaa()
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
    
    func fetchFavorites() async throws -> [Int] {
        let url = URL(string: "https://hws.dev/user-favorites.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Int].self, from: data)
    }
    
    
    
}





