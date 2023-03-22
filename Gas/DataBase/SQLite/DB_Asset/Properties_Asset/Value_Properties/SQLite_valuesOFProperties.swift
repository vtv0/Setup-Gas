//
//  SQLite_value.swift
//  Gas
//
//  Created by Vuong The Vu on 06/03/2023.
//

import UIKit
import FMDB
import SQLite3

class ValuesOfProperties: NSObject {
    var address = "address"
    var customer_location = "customer_location"
    var customer_name = "customer_name"
    
//    var display_data: DisplayData
    var gas_location1 = "gas_location1"
    var gas_location2 = "gas_location2"
    var gas_location3 = "gas_location3"
    var gas_location4 = "gas_location4"
    
    var kyokyusetsubi_code = "kyokyusetsubi_code"
//    var location: LocationDetail
    var notes = "notes"
    var parking_place1 = "parking_place1"
    var parking_place2 = "parking_place2"
    var parking_place3 = "parking_place3"
    var parking_place4 = "parking_place4"
    //    var time_window = "time_window"
    var total_cylinder_count = "total_cylinder_count"
    var vehicle_limit = "vehicle_limit"
    //    var workable_day = "workable_day"
    
    static let shared: ValuesOfProperties = ValuesOfProperties()
    
    var dbFileName_Value = "dbValue.sqlite"
    
    var pathToDatabaseValue : String!
    
    var dbValue: FMDatabase!
    
    override init() {
        super.init()
        
//        let documentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
//        pathToDatabaseValue = documentDirectory.appending("/\(dbFileName_Value)")
//        print(pathToDatabaseValue)
//
    }
    
    func createTable() -> Bool {
       var create = false
        if !FileManager.default.fileExists(atPath: pathToDatabaseValue) {
            dbValue = FMDatabase(path: pathToDatabaseValue)
            if dbValue != nil {
//                if dbValue.open() {
                    let createTableValue = "create table Value (\(address), \(customer_location) ,\(customer_name), \(gas_location1), \(gas_location2), \(gas_location3), \(gas_location4), \(kyokyusetsubi_code), \(notes), \(parking_place1), \(parking_place2), \(parking_place3), \(parking_place4), \(total_cylinder_count), \(vehicle_limit) )"
                    
                    do {
                        try dbValue.executeUpdate(createTableValue, values: nil)
                        create = true
                    } catch {
                        print(error.localizedDescription)
                    }
//                }
            }
        }
        return create
    }
    
}
