//
//  SQLite_Asset.swift
//  Gas
//
//  Created by Vuong The Vu on 03/03/2023.
//

import UIKit
import FMDB
import SQLite3
import SQLite

class DBAsset: NSObject {
    let assetModelID = "assetModelID"
    let createdAt = "createdAt"
    let enabled = "enabled"
    
    // let geoloc: GeolocDetail?
    let geoloc_coordinates = "geoloc_coordinates"
    let geoloc_type = "geoloc_type"
    
    var id = "id"
    let metedata = "metedata"
    let name = "name"
    
//    let properties: PropertiesDetail?
    let properties_etag = "properties_etag"
    let properties_updatedAt = "properties_updatedAt"
    let properties_values_address = "properties_values_address"
    let properties_values_customer_location = "properties_values_customer_location"
    let properties_valuse_customer_name = "properties_valuse_customer_name"
    
    let properties_values_gas_location1 = "properties_values_gas_location1"
    let properties_values_gas_location2 = "properties_values_gas_location2"
    let properties_values_gas_location3 = "properties_values_gas_location3"
    let properties_values_gas_location4 = "properties_values_gas_location4"
    let properties_values_parking_place1 = "properties_values_parking_place1"
    let properties_values_parking_place2 = "properties_values_parking_place2"

    let properties_values_parking_place3 = "properties_values_parking_place3"

    let properties_values_parking_place4 = "properties_values_parking_place4"

    
    
    let tenantID = "tenantID"
    let updatedAt = "updatedAt"
    let version = "version"
    let vendorThingID = "vendorThingID"
//    gas_location1
    
    
    
    static let shared: DBAsset = DBAsset()
    
    let databaseFileName = "databaseAsset.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    var connection: Connection?
    
    var propertiesNewsTable = DBProperties()
    var geolocNewsTable = DBGeoloc()
    
    // khoi tao
    override init() {
        super.init()
        
//        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
//        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
//        
//        print(pathToDatabase)
    }
    
    func arrimage () {
        
    }
    
    
    
    
    // ham tao ra bang DataBase
    
//    func createAssetDatabase() -> Bool {
//        var created = false
//
//        if !FileManager.default.fileExists(atPath: pathToDatabase) {  // kiểm tra fileManagee có tồn tại theo Path hay không
//            // nếu không tồn tại -> tạo ra file theo đường dẫn
//            database = FMDatabase(path: pathToDatabase!) // đã hộ trợ tạo BD
//            if database != nil {
//                if database.open() {                  //  primary key autoincrement not null
//                    let createAssetTableQuery = " create table asset ( \(assetModelID) integer, \(createdAt) text ,\(enabled) bool not null, \(id) text, \(metedata) text not null, \(name) text, \(tenantID) interger, \(updatedAt) text not null, \(version) integer, \(vendorThingID) text not null )"
//                    do {
//                        try database.executeUpdate(createAssetTableQuery, values: nil)
//                        created = true
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                } else {
//                    print("khong mo duoc DB")
//                }
//            }
//        }
//        return created
//    }
    
    func loadAsset() {
        
        
    }
    
    //
    //    func openDatabase() -> Bool {
    //        if database == nil {
    //            if FileManager.default.fileExists(atPath: pathToDatabase) {
    //                database = FMDatabase(path: pathToDatabase)
    //            }
    //
    //        } else {
    //            if database.open() {
    //                return true
    //            }
    //        }
    //        return false
    //    }
    
//    func insert(/* tham so dau vao */) {
//        if database.open() {
//
//            let query = "insert into asset (\(assetModelID), \(createdAt)) values ( ?, ?);"
//            do {
//                try database.executeUpdate(query, values: [4, "9999"])
//                try database.executeUpdate(query, values: [5, "8888"])
//                try database.executeUpdate(query, values: [6, "7777"])
//
//
//            } catch {
//                print(error.localizedDescription)
//            }
//            database.close()
//        }
//    }
    //MARK: - Insert Geoloc
    // ham insert geoloc
//    func insertGeoloc() {
//        if database.open() {
//            
//            let query = "insert into asset (\(geolocNewsTable.coordinates) , \(geolocNewsTable.type)) values ( ?, ?);"
//            do {
//                try database.executeUpdate(query, values: [1, "mmmmmmmmmm"])
//                try database.executeUpdate(query, values: [2, "nnnnnnn"])
//                try database.executeUpdate(query, values: [3, "jjj"])
//                
//                // lay ra
//                
//                let rs = try database.executeQuery("select * from asset ", values: nil)
//                print(rs)
//                
//            } catch {
//                print(error.localizedDescription)
//            }
//            database.close()
//            
//        }
//        
//        // ham insert properties
//        func insertDataForProperties() {
//            propertiesNewsTable.updatedAt = properties_updatedAt
//        }
//        
//        
//    }
    
}
