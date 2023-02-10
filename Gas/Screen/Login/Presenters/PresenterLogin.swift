//
//  PresenterLogin.swift
//  Gas
//
//  Created by Vuong The Vu on 10/02/2023.
//

import Foundation
import Alamofire

protocol LoginVCDelegateProtocol: AnyObject {
    func loginOK()
}

class PresenterLogin {
    weak var loginDelegate: LoginVCDelegateProtocol?
    init() { }
    
    func setViewDelegate(delegateLogin: LoginVCDelegateProtocol?) {
        self.loginDelegate = delegateLogin
        
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }

    
    func callAPI_Block(name: String, pass: String, companyCode: String) {
        PostGetToken_Block().postGetToken_Block(username: name /*txtUserName.text!*/, pass: pass /*txtPass.text!*/, companyCode: companyCode /*txtcompanyCode.text!*/) { [self] token, error  in
            if token != nil {
                UserDefaults.standard.set(token, forKey: "accessToken")
                GetMe_Block().getMe_Block(commpanyCode: companyCode  /*txtcompanyCode.text!*/, acccessToken: token ?? "") { (dataID, detailError) in
                    if !dataID.isEmpty {
                        UserDefaults.standard.set(dataID[0], forKey: "tenantId")
                        UserDefaults.standard.set(dataID[1], forKey: "userId")
                        self.loginDelegate?.loginOK()
                    }
                }
            } else if token == nil {
                let err = error
                switch err {
                case .wrongPassword:
                    print(401)
//                    showAlert(message: "Sai thông tin tài khoản")
//                    hideActivity()
                case .ok: break
                case .tokenOutOfDate:
//                    let mhLogin = self.storyboard?.instantiateViewController(identifier:  "LoginViewController") as! ViewController
//                    self.navigationController?.pushViewController(mhLogin, animated: true)
                    print(403)
//                    hideActivity()
                case .remain:
                    break
//                    showAlert(message: "Có lỗi xảy ra")
//                    hideActivity()
                case .none:
                    break
                case .some(.wrongURL):
                    break
//                    showAlert(message: "Sai thông tin tài khoản")
//                    hideActivity()
                }
            }
        }
    }
    
}
