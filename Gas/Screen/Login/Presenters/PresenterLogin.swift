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
    func loginError(err: Error)
    func getMeError(err: Error)
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
        PostGetToken_Block().postGetToken_Block(username: name, pass: pass, companyCode: companyCode) { [self] token, errorGetToken  in
            if let errToken = errorGetToken {
                loginDelegate?.loginError(err: errToken)
            } else {
                
                UserDefaults.standard.set(token, forKey: "accessToken")
                GetMe_Block().getMe_Block(commpanyCode: companyCode, acccessToken: token ?? "") { [self] dataID, detailError in
                    if let err = detailError {
                        loginDelegate?.getMeError(err: err)
                    } else {
                        UserDefaults.standard.set(dataID[0], forKey: "tenantId")
                        UserDefaults.standard.set(dataID[1], forKey: "userId")
                        self.loginDelegate?.loginOK()
                        
                        // luu thong tin tai khoan khi da login duoc
                        UserDefaults.standard.set(name, forKey: "userName")
                        UserDefaults.standard.set(pass, forKey: "pass")
                        UserDefaults.standard.set(companyCode, forKey: "companyCode")
                    }
                }
            }
        }
    }
    
    
    func callAPI_Async_Await(name: String, pass: String, companyCode: String) async {
        do {
            let getTokenResponse = try await PostGetToken_Async_Await().getToken_Async_Await(userName: name, pass: pass, companyCode: companyCode)
            
            
            do {
                let responseGetMe = try await GetMe_Async_Await().getMe_Async_Await(companyCode: companyCode, token: getTokenResponse)
             print(responseGetMe)
                DispatchQueue.main.async {
                    self.loginDelegate?.loginOK()
                }
                // luu thong tin tai khoan khi da login thanh cong
                UserDefaults.standard.set(name, forKey: "userName")
                UserDefaults.standard.set(pass, forKey: "pass")
                UserDefaults.standard.set(companyCode, forKey: "companyCode")
            } catch {
                loginDelegate?.getMeError(err: error)
            }
        } catch {
            loginDelegate?.loginError(err: error)
        }
    }
    
}
