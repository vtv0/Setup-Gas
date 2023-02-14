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
    
    let presenter = PresenterLogin()
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
        if txtUserName.text!.isEmpty || txtPass.text!.isEmpty || txtcompanyCode.text!.isEmpty {
            self.showAlert(message: "Nhập đầy đủ thông tin tài khoản")
        } else {
            showActivity()
            
            //MARK: - Block
            //            presenter.callAPI_Block(name: txtUserName.text ?? "", pass: txtPass.text ?? "", companyCode: txtcompanyCode.text ?? "")
            
            
            //MARK: - Use ASYNC AWAIT
            Task {
                await presenter.callAPI_Async_Await(name: txtUserName.text ?? "", pass: txtPass.text ?? "" ,companyCode: txtcompanyCode.text ?? "")
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let showUserName = UserDefaults.standard.string(forKey: "userName") ?? ""           //"dev_driver1@dev2.test"
        let showPass = UserDefaults.standard.string(forKey: "pass") ?? ""                   // "dev123456"
        let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""     // "am-stg-iw01j"
        
        presenter.loginDelegate = self
        
        if !showUserName.isEmpty {
            btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
            txtUserName.text = showUserName
            txtPass.text = showPass
            txtcompanyCode.text = showcompanyCode
        } else {
            btnSaveAccount.setImage(UIImage(named: "checkmarkEmpty"), for: .normal)
        }
        imgIcon.image = UIImage(named:"application_splash_logo")
        
        
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
    
    
    func showAlert(title: String? = "", message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
}

extension ViewController: LoginVCDelegateProtocol {
    func loginOutOfDate_Token() {
        let mhLogin = self.storyboard?.instantiateViewController(identifier:  "LoginViewController") as! ViewController
        self.navigationController?.pushViewController(mhLogin, animated: true)
        showAlert(message: "Token đã hết hạn 1111")
        hideActivity()
    }
    
    func loginOK() {
//        let mhDeliveryList = storyboard?.instantiateViewController(withIdentifier: "DeliveryListController") as! DeliveryListController
//        self.navigationController?.pushViewController(mhDeliveryList, animated: true)
        
        let screenExpand = storyboard?.instantiateViewController(withIdentifier: "ScreenExpandVC") as! ScreenExpandVC
        self.navigationController?.pushViewController(screenExpand, animated: true)

        hideActivity()
    }
    
}



