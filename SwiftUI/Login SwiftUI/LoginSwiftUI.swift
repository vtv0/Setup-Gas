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
    @State private var arrInt: [Int] = []
    
    @State var checked: Bool = false
    
    //    @ObservedObject var ApiPost = PostGetToken_Async_Await()
    @State private var presentAlert = false
    
//    @Binding var GotoPageDeliveryList: Bool
    
    var body: some View {
        
        @AppStorage("username") var userName: String = userName
        @AppStorage("pass") var pass: String = pass
        @AppStorage("companyCode") var companyCode: String = companyCode
        
//        NavigationView {
            VStack(alignment: .center, spacing: 30) {
                
                Image("application_splash_logo")
                
                TextField("Username", text: $userName)
                    .border(Color.black, width: 2)
                    .cornerRadius(5)
                    .padding(.horizontal, 30)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $pass)
                    .border(Color.black, width: 2)
                    .cornerRadius(5)
                    .padding(.horizontal, 30)
                    .autocapitalization(.none)
                    .textContentType(.password)
                
                TextField("Companycode", text: $companyCode)
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
                
                NavigationLink(destination: DeliveryListSwiftUI()) {
                    Text("Chuyển View")
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .tint(Color.white)
                    
                }
                
                Button(action: {
                    // nhac toi ham call Post
                    Task {
                        //                    callAPI_Async_Await.
                        do {
                            token = try await PostGetToken_Async_Await().getToken_Async_Await(userName: userName, pass: pass, companyCode: companyCode)
                            
                            do {
                                arrInt = try await GetMe_Async_Await().getMe_Async_Await(companyCode: companyCode, token: token)
                                print(arrInt)
                            } catch {
                                // loi phan getMe
                                //
                                print(error)
                                
                            }
                            
                        } catch {
                            print(error)
                            // loi phan post
                        }
                        
                    }
                    
                    
                }) {
                    //                VStack {
                    //                    ProgressView() // indicator
                    //                }
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Login")
                            .tint(Color.white)
                        Spacer()
                    }
                    
                    .background(Color.blue)
                    .cornerRadius(5)
                    .padding(.horizontal, 30 )
                }
            }
//        }
        .onChange(of: arrInt) { newValue in
            if arrInt.isEmpty {
                // show Alert
                print("tach tach tach")
                presentAlert = true
                //
                //                }
            } else {
                // ham getMe
                print("okokokokokok")
                
//                NavigationLink(destination: DeliveryListSwiftUI()) {
//                    Text("Chuyen view")
//                        .frame(maxWidth: . infinity)
//                }
            }
        }
        
//        .alert("sdfasdfasdfsda", isPresented: $presentAlert, actions: {
//            Button("OK",role: .cancel, action: { })
//        })
//
        .alert("g", isPresented: $presentAlert) { }
    }
    
}

struct MyCustomView: View {
    var function: () -> Void
    var body: some View {
        Button(action: {
            self.function()
        }, label: {
            Text("aaaaaaaaaaaaa")
        })
    }
}

struct LoginSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        LoginSwiftUI()
    }
}
