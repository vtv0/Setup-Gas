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
    
    @State var checked: Bool = false
    
    var body: some View {
        
        @AppStorage("username") var userName: String = userName
        @AppStorage("pass") var pass: String = pass
        @AppStorage("companyCode") var companyCode: String = companyCode
        
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
            
            
            Button(action: {
                print("button Click")
                print(userName)
                print(pass)
                print(companyCode)
                
                Task {
//                    callAPI_Async_Await.
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
