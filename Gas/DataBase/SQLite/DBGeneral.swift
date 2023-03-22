//
//  DBGeneral.swift
//  Gas
//
//  Created by Vuong The Vu on 08/03/2023.
//

import UIKit
import SQLite3
import SQLite
import FMDB


class DBGeneral: NSObject {
    
    static let shared: DBGeneral = DBGeneral()
    let databaseFileName = "databaseGeneral.sqlite"
    
    var pathdatabase: String!
    
    var dbGeneral: FMDatabase!
    
    
    
    let asset = DBAsset()
    let elem = DBElem()
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathdatabase = documentsDirectory.appending("/\(databaseFileName)")
        
        print(pathdatabase)
    }
    
    func createDBGeneral() -> Bool {
        
        var create = false
        
        if !FileManager.default.fileExists(atPath: pathdatabase) {
            dbGeneral = FMDatabase(path: pathdatabase!)
            if dbGeneral != nil {
                if dbGeneral.open() {
                    let createDBGeneral = " create table tblGeneral ( id integer )"
                   
                    do {
                        try dbGeneral.executeQuery(createDBGeneral, values: nil)
                        
                        create = true
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
        }
        return create
    }
    
//    func createTableElem() {
//        if dbGeneral.open() {
////            let createTableElem = elem.createElem
//            print(createTableElem)
//            
//            do {
//                try dbGeneral.executeQuery(createTableElem, values: nil)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    
}
