//
//  DB_GET_SET.swift
//  Gas
//
//  Created by Vuong The Vu on 13/01/2023.
//

import UIKit

protocol DB_Protocol {
    var userName: String { get set }
    var pass: String { get set }
    var companyCode: String { get set }
}

public class DB {
//    var userNameNew: String = ""
    
    var userName: String {
        get { return "" }
        set {
//            if newValue != userNameNew {
//                self.userName = userNameNew
//            }
            
        }
    }

    var pass: String {
        get { return  "" }
        set { }
    }
    
    var companyCode: String {
        get { return "" }
        set { }
    }
    
    init( UserName: String, Pass: String, CompanyCode: String) {
        userName = UserName
        pass = Pass
        companyCode = CompanyCode
    }
}


