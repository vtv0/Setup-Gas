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
    func loginOutOfDate_Token()
//    func login_Async_Await()
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
                        
                        // luu thong tin tai khoan khi da login duoc
                        UserDefaults.standard.set(name, forKey: "userName")
                        UserDefaults.standard.set(pass, forKey: "pass")
                        UserDefaults.standard.set(companyCode, forKey: "companyCode")
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
    
    
    func callAPI_Async_Await(name: String, pass: String, companyCode: String) async {
        do {
            let getTokenResponse = try await PostGetToken_Async_Await().getToken_Async_Await(userName: name, pass: pass, companyCode: companyCode)
            print(getTokenResponse)
            
            do {
                let responseGetMe = try await GetMe_Async_Await().getMe_Async_Await(companyCode: companyCode)
                print(responseGetMe)
                DispatchQueue.main.async {
                    self.loginDelegate?.loginOK()
                }
                
                // luu thong tin tai khoan khi da login thanh cong
                UserDefaults.standard.set(name, forKey: "userName")
                UserDefaults.standard.set(pass, forKey: "pass")
                UserDefaults.standard.set(companyCode, forKey: "companyCode")

                
            } catch {
                if let err = error as? GetMe_Async_Await.AFError {
                    if err == .tokenOutOfDate {
                        DispatchQueue.main.async {
                            self.loginDelegate?.loginOutOfDate_Token()
                        }
                        
                    } else if err == .remain {
//                        showAlert(message: "Có lỗi xảy ra")
//                        hideActivity()
                    }
                }
            }
        } catch {
            if let err = error as? PostGetToken_Async_Await.AFError {
                if err == .wrongURL {
//                    showAlert(message: "Sai companyCode")
//                    hideActivity()
                } else if err == .wrongPassword {
//                    showAlert(message: "Sai password")
//                    hideActivity()
                } else if err == .remain {
//                    showAlert(message: "Có lỗi xảy ra")
//                    hideActivity()
                }
            }
        }
    }

    
}
