//
//  SQLite_delivery_history.swift
//  Gas
//
//  Created by Vuong The Vu on 06/03/2023.
//

import FMDB
import UIKit
import SQLite3

class DeliveryHistory_Asset: NSObject {
    var id = "id"
    var date = "date"
    var status = "status"
    
    
    static let shared: DeliveryHistory_Asset = DeliveryHistory_Asset()
    let dbFileName_Delivery = "dbDeliveryValuesProperties"
    
    var pathToDB_DeliveryHistory: String!
    
    var databaseDeliveryHistory: FMDatabase!
    
    override init() {
        super.init()
//        let documentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
//        pathToDB_DeliveryHistory = documentDirectory.appending("/\(dbFileName_Delivery)")
//        print(pathToDB_DeliveryHistory)
    }
    
    func createDeliveryHistory_Properties_AssetDB() -> Bool {
        var create = false
        if !FileManager.default.fileExists(atPath: pathToDB_DeliveryHistory) {
            databaseDeliveryHistory = FMDatabase(path: pathToDB_DeliveryHistory)
            
            if databaseDeliveryHistory != nil {
//                if databaseDeliveryHistory.open() {
                    let createQuery = "create table DeliveryHistory (\(id) text not null, \(date) text, \(status) text )"
                    do {
                        try databaseDeliveryHistory.executeUpdate(createQuery, values: nil)
                        create = true
                    } catch {
                        print(error.localizedDescription)
                    }
//                }
            }
        }
        return create
        
    }
    
    func insertDeliveryHistory(id: String) {
       if databaseDeliveryHistory.open() {
            let query = " insert into DeliveryHistory (\(id), \(date), \(status)) values (?, ?, ?);"
            
            do {
                try databaseDeliveryHistory.executeUpdate(query, values: ["www", "2023/03/08", "Point"] )
            } catch {
                
            }
            
            databaseDeliveryHistory.close()
        }
        
    }
    
    
}
