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
    
    @State var checked: Bool = true
    
    @State private var presentAlert = false
    @State private var path = NavigationPath()
    
    @State private var showLogin = false
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
                        .border(Color.black, width: 2)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $pass)
                        .frame(height: 30)
                        .border(Color.black, width: 2)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                        .autocapitalization(.none)
                        .textContentType(.password)
                    
                    TextField("Companycode", text: $companyCode)
                        .frame(height: 30)
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
                        self.showLogin = !self.showLogin
                        
                        showActivity()
                        // nhac toi ham call Post
                        Task {
                            do {
                                token = try await PostGetToken_Async_Await().getToken_Async_Await(userName: userName, pass: pass, companyCode: companyCode)
                                do {
                                    arrInt = try await GetMe_Async_Await().getMe_Async_Await(companyCode: companyCode, token: token)
                                 
                                    tenantID = arrInt[0]
                                    userID = arrInt[1]
                                } catch {
                                    print(error)
                                    presentAlert = true
                                    statusCode = "\(error)"
                                }
                            } catch {
                                print(error)
                                // loi phan post
                                presentAlert = true
                                statusCode = "\(error)"
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
                
                .navigationDestination(isPresented: $showLogin) {
                    DeliveryListSwiftUI()
                        .background(Color.yellow)
                        .navigationBarBackButtonHidden()
                }
                
            }
            
            if isActivityIndicator {  // show indicator
                LoadingView()
            }
            
        }
        
        .onChange(of: tenantID) { newValue in
            if arrInt.isEmpty {
                // show Alert
                
                print("tach tach tach")
                isActivityIndicator = false
            } else {
                // ham getMe
                print("okokokokokok")
                showLogin = true
                
            }
            
        }
        
        .alert("\(statusCode)", isPresented: $presentAlert) {}
        
    }
    
    func showActivity() {
        isActivityIndicator = true // show Activity
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            isActivityIndicator = false
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
            Color(red: 2, green: 2, blue: 1)
                // .ignoresSafeArea()
                .opacity(0.8)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                .scaleEffect(3)
            
        }
    }
}
