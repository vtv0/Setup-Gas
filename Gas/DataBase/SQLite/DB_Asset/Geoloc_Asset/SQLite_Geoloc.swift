//
//  SQLite_Geoloc.swift
//  Gas
//
//  Created by Vuong The Vu on 06/03/2023.
//

import UIKit
import FMDB
import SQLite3
import SQLite

class DBGeoloc: NSObject {
//    var id = "id"
    var coordinates = "coordinates"
    var type = "type"
    
    static let shared: DBGeoloc = DBGeoloc()
    
    let dbFileName_Geoloc = "databaseGeolocAsset.sqlite"
    
    var pathToDatabaseGeoloc: String!
    
    var databaseGeoloc: FMDatabase!
    
    //init()
    override init() {
        super.init()
        
//        let documentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
//        pathToDatabaseGeoloc = documentDirectory.appending("/\(dbFileName_Geoloc)")
//        print(pathToDatabaseGeoloc)
        
    }
    
    func createGeoloc_AssetDatabase() -> Bool {
        var didCreate = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabaseGeoloc) {
            databaseGeoloc = FMDatabase(path: pathToDatabaseGeoloc)
            if databaseGeoloc != nil {
                //                if databaseGeoloc.open() {
                let createGeolocTableQuery = " create table geolocAsset (\(coordinates) [float], \(type) String )"
                
                do {
                    try databaseGeoloc.executeUpdate(createGeolocTableQuery, values: nil)
                    didCreate = true
                } catch {
                    print(error.localizedDescription)
                }
                
//            }
            }
        }
        
        return didCreate
    }
    
    
//    func insertGeoLoc() {
//        if databaseGeoloc.open() {
//            let query = " insert into geolocAsset (\(id), \(coordinates), \(type)) values (?, ?, ?);"
//
//            do {
//                try databaseGeoloc.executeUpdate(query, values: ["th.7b3f20b00022-4abb-ce11-cebd-cd27f0c8", [139.6533594,35.7294291], "Point"])
//            } catch {
//                print(error.localizedDescription)
//            }
//            databaseGeoloc.close()
//        }
//    }
    
    
}
