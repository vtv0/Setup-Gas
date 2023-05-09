//
//  LoginSwiftUI.swift
//  Gas
//
//  Created by Vuong The Vu on 28/04/2023.
//

import SwiftUI

struct LoginSwiftUI: View {
    
    @State private var userName: String = ""
    @State private var pass: String = ""
    @State private var companyCode: String = ""
    
    @State private var token: String = ""
    @State private var statusCode: String = ""
    
    @State private var arrInt: [Int] = []
    @State private var tenantID: Int = 0
    @State private var userID: Int = 0
    @State private var isArrInt: Bool = false
    
    @State var checked: Bool = true
    
    @State private var presentAlert = false
    @State private var path = NavigationPath()
    
    
    @State private var isActivityIndicator = false
    
    
    var body: some View {
        
        @AppStorage("username") var userName: String = userName
        @AppStorage("pass") var pass: String = pass
        @AppStorage("companyCode") var companyCode: String = companyCode
        
        ZStack {
            NavigationStack {
                VStack(alignment: .center, spacing: 30) {
                    
                    Image("application_splash_logo")
                    
                    TextField("Username", text: $userName)
                        .frame(height: 30)
                        .padding(.leading, 6)
                        .border(Color.black, width: 2)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                        .autocapitalization(.none)
                       
                    
                    SecureField("Password", text: $pass)
                        .frame(height: 30)
                        .padding(.leading, 6)
                        .border(Color.black, width: 2)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                        .autocapitalization(.none)
                        .textContentType(.password)
                    
                    TextField("Companycode", text: $companyCode)
                        .frame(height: 30)
                        .padding(.leading, 6)
                        .border(Color.black, width: 2)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                        .autocapitalization(.none)
                    
                    
                    Button(action: {
                        self.checked = !self.checked
                    }) {
                        HStack(alignment: .center, spacing: 10) {
                            Rectangle()
                                .frame(width: 20, height: 20)
                                .overlay {
                                    Image(systemName: checked ? "checkmark" : "checkmarkEmpty")
                                        .frame(width: 20, height: 20)
                                        .border(.black)
                                        .background(Color.white)
                                }
                            
                            Text("Lưu đăng nhập")
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                        .background(Color.white)
                    }
                    
                    
                    
                    Button(action: {
                        
                        
                        if userName.isEmpty || pass.isEmpty || companyCode.isEmpty {
                            presentAlert = true
                            statusCode = "Hãy nhập đủ thông tin tài khoản"
                        } else {  // call Post API
                            isActivityIndicator = true
                            Task {
                                do {
                                    token = try await PostGetToken_Async_Await().getToken_Async_Await(userName: userName, pass: pass, companyCode: companyCode)
                                    do {
                                        arrInt = try await GetMe_Async_Await().getMe_Async_Await(companyCode: companyCode, token: token)
                                        
                                        //                                    tenantID = arrInt[0]
                                        //                                    userID = arrInt[1]
                                        isArrInt = true
                                        UserDefaults.standard.set(userName, forKey: "username")
                                        UserDefaults.standard.set(pass, forKey: "pass")
                                        UserDefaults.standard.set(companyCode, forKey: "companuCode")
                                        
                                    } catch {
                                        presentAlert = true
                                        // statusCode = "\(error)"
                                        let err = error as? GetMe_Async_Await.AFError
                                        if err == .tokenOutOfDate {
                                            statusCode = "Token hết hạn"
                                        } else if err == .wrongPassword {
                                            statusCode = "Sai password"
                                            
                                        } else {
                                           
                                            statusCode = "Có lỗi xảy ra"
                                        }
                                        isActivityIndicator = false
                                    }
                                } catch {
                               
                                    // loi phan post
                                    presentAlert = true
                                    
                                    let err = error as? PostGetToken_Async_Await.AFError
                                    if err == .tokenOutOfDate {
                                        statusCode = "Token hết hạn"
                                    } else if err == .wrongPassword {
                                        statusCode = "Sai password"
                                    } else {
                                        statusCode = "Có lỗi xảy ra"
                                    }
                                    isActivityIndicator = false
                                }
                            }
                            
                        }
                    }) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Login")
                                .tint(Color.white)
                            Spacer()
                        }
                        .frame(height: 30)
                        .background(Color.blue)
                        .cornerRadius(5)
                        .padding(.horizontal, 30 )
                        
                    }
                }
                
                
                
                // sau khi nhan dc userID , tenantID
                .navigationDestination(isPresented: $isArrInt) {  // chuyen man hinh  nhanh
                    DeliveryListSwiftUI()
                        .background(Color.yellow)
                        .navigationBarBackButtonHidden()
                    // hiden activity
                    
                }
                
            }
            
            if isActivityIndicator {  // show indicator
                LoadingView()
            }
            
        }
        
        .onChange(of: arrInt) { newValue in
            if arrInt.isEmpty {
                // show Alert
                isActivityIndicator = false
            } else {
                // ham getMe
                isActivityIndicator = false
            }
        }
        
        .alert("\(statusCode)", isPresented: $presentAlert) {
    
        }
    }
}

struct LoginSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        LoginSwiftUI()
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color("colorCustom")


            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                .scaleEffect(3)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

