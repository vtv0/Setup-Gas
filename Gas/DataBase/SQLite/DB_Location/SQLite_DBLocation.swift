//
//  SQLite_DB.swift
//  Gas
//
//  Created by Vuong The Vu on 03/03/2023.
//

import UIKit
import SQLite3
import SQLite
import FMDB



//class DBLocation: NSObject {
//    var elem: DBElem?
//    var asset: DBAsset?
//}

class DBLocation: NSObject {
    var arrivalTime_hour = "arrivalTime_hour"
    var arrivalTime_minutes = "arrivalTime_minutes"
    let arrivalTime_nanos = "arrivalTime_nanos"
    let arrivalTime_seconds = "arrivalTime_seconds"
    var date = "date"
    
    let breakTimeSec = "breakTimeSec"
    let createdAt = "createdAt"
    let latitude = "latitude"
    let loadCapacity = "loadCapacity"
    let loadSupply = "loadSupply"
    
    //  var location = "location"
    let location_areaID = "location_areaID"
    var location_assetID = "location_assetID"
    let location_comment = "location_comment"
    let location_createdAt = "location_createdAt"
    let location_id = "location_id"
    let location_importance = "location_importance"
    let location_latitude = "location_latitude"
    let location_loadCapacity = "location_loadCapacity"
    let location_loadConsumeMax = "location_loadConsumeMax"
    let location_loadConsumeMin = "location_loadConsumeMin"
    let location_locationType = "location_locationType"
    let location_longitude = "location_longitude"
    //  let location_metadata = "location_metadata"
    let location_normalizedScore = "location_normalizedScore"
    let location_priority = "location_priority"
    let location_tenantID = "location_tenantID"
    let location_timeWindow = "location_timeWindow"
    let location_updatedAt = "location_updatedAt"
    let location_vehicleLimit = "location_vehicleLimit"
    let location_workTimeSec = "location_workTimeSec"
    
    
    
    let locationID = "locationID"
    let locationOrder = "locationOrder"
    let longitude = "longitude"
    
    //  var metadata = "metadata"
    var metadata_customer_id = "metadata_customer_id"
    let metadata_deliver_type = "metadata_deliver_type"
    let metadata_onetime_notes = "metadata_onetime_notes"
    let metadata_optional_days = "metadata_optional_days"
    let metadata_optional_location = "metadata_optional_location"
    let metadata_plan_id = "metadata_customer_id"
    let metadata_plan_type = "metadata_plan_type"
    let metadata_planned_date = "metadata_planned_date"
    let metadata_prev_date = "metadata_prev_date"
    
    //  let timeWindow = "timeWindow"
    let travelTimeSecToNext = "travelTimeSecToNext"
    let waitingTimeSec = "waitingTimeSec"
    let workTimeSec = "workTimeSec"
    var workerRoute_createdAt = "workerRoute_createdAt"
    
    
    static let shared: DBLocation = DBLocation()
    let databaseFileName = "databaseGeneral.sqlite"
    var pathFileName: String!
    var database: FMDatabase!
    var deliveryHistoryElem = DeliveryHistory_Elem()
    var asset = DBAsset()
    
    override init() {
        super.init()
        let doccumentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathFileName = doccumentDirectory.appending("/\(databaseFileName)")
        print(pathFileName)
    }
    
    
    //MARK: - Tao bang trong FMDB
    func createDatabaseElem() -> Bool {
        var create = false
        if !FileManager.default.fileExists(atPath: pathFileName) {
            database = FMDatabase(path: pathFileName)
            
            if database != nil {
                if database.open() {
                    let createElem = """
                                    create table elem (
                                    \(location_assetID) text Primary key not null,
                                    \(date) date null,
                                    \(arrivalTime_hour) interger,
                                    \(arrivalTime_minutes) interger,
                                    \(metadata_customer_id) text null,
                                    \(workerRoute_createdAt) text null
                                    )
                                    """
                    //                    let createAssetTableQuery = "create table asset ( assetModelID integer, createdAt text , enabled bool not null, id text, metedata text not null, name text,tenantID interger, updatedAt text not null, version integer, vendorThingID text not null )"
                    do {
                        try database.executeUpdate(createElem, values: nil)
                        //                        try dbElem.executeUpdate(createAssetTableQuery, values: nil)
                        create = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            database = FMDatabase(path: pathFileName)
            create = false
        }
        return create
        
    }
    func createTableAsset() {
        if database.open() {
            let createAssetTableQuery = """
                                    create table asset (
                                    \(asset.id) text Primary key not null,
                                    \(asset.properties_values_address) text null,
                                    \(asset.properties_valuse_customer_name) text,
                                    \(asset.properties_values_gas_location1) text,
                                    \(asset.properties_values_gas_location2) text,
                                    \(asset.properties_values_gas_location3) text,
                                    \(asset.properties_values_gas_location4) text,
                                    \(asset.properties_values_parking_place1) text,
                                    \(asset.properties_values_parking_place2) text,
                                    \(asset.properties_values_parking_place3) text,
                                    \(asset.properties_values_parking_place4) text
                                    )
                                    """
            
            do {
                try database.executeUpdate(createAssetTableQuery, values: nil)
                
            } catch {
                print(error.localizedDescription)
                
            }
            
            database.close()
        }
    }
    
    
    
    //MARK: - Ham them data  // Đang bị lỗi trong logic của SQL || Tạm thời bỏ qua
    // insert data
    func insertDataElem(ilocation: Location, deliveryDate: Date, createdAt: String) {
        if database.open() {
            let queryInsertElem = """
                                    insert into elem (
                                    \(self.location_assetID),
                                    \(self.date),
                                    \(self.arrivalTime_hour),
                                    \(self.arrivalTime_minutes),
                                    \(self.metadata_customer_id),
                                    \(self.workerRoute_createdAt) )
                                    values (?, ?, ?, ?, ?, ?);
                                    """
            
            do {
                if let iassetID = ilocation.elem?.location?.assetID,
                   let iarrivalTime_hour = ilocation.elem?.arrivalTime?.hours,
                   let iarrivalTime_minutes = ilocation.elem?.arrivalTime?.minutes,
                   let icustomer_id = ilocation.elem?.metadata?.customer_id {
                    
                    try database.executeUpdate(queryInsertElem, values: ["\(iassetID)", "\(deliveryDate)", "\(iarrivalTime_hour)", "\(iarrivalTime_minutes)", "\(icustomer_id)", "\(createdAt)"])
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        database.close()
    }
    
    func insertDataAsset(iGetAsset: GetAsset) {
        
        if database.open() {
            let queryInsertAsset = """
                                insert into asset (
                                \(self.asset.id),
                                \(self.asset.properties_values_address),
                                \(self.asset.properties_valuse_customer_name),
                                \(self.asset.properties_values_gas_location1),
                                \(self.asset.properties_values_gas_location2),
                                \(self.asset.properties_values_gas_location3),
                                \(self.asset.properties_values_gas_location4),
                                \(self.asset.properties_values_parking_place1),
                                \(self.asset.properties_values_parking_place2),
                                \(self.asset.properties_values_parking_place3),
                                \(self.asset.properties_values_parking_place4) )
                                values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
                                """
            do {
                
                if let asset_id = iGetAsset.id,
                   let asset_properties_values_address = iGetAsset.properties?.values.address,
                   let asset_properties_valuse_customer_name = iGetAsset.properties?.values.customer_name,
                   let asset_properties_values_gas_location1 = iGetAsset.properties?.values.gas_location1,
                   let asset_properties_values_gas_location2 = iGetAsset.properties?.values.gas_location2,
                   let asset_properties_values_gas_location3 = iGetAsset.properties?.values.gas_location3,
                   let asset_properties_values_gas_location4 = iGetAsset.properties?.values.gas_location4,
                   let asset_properties_values_parking_place1 = iGetAsset.properties?.values.parking_place1,
                   let asset_properties_values_parking_place2 = iGetAsset.properties?.values.parking_place2,
                   let asset_properties_values_parking_place3 = iGetAsset.properties?.values.parking_place3,
                   let asset_properties_values_parking_place4 = iGetAsset.properties?.values.parking_place4 {
                    
                    try database.executeUpdate(queryInsertAsset, values: ["\(asset_id)", "\(asset_properties_values_address)", "\(asset_properties_valuse_customer_name)", "\(asset_properties_values_gas_location1)", "\(asset_properties_values_gas_location2)", "\(asset_properties_values_gas_location3)", "\(asset_properties_values_gas_location4)", "\(asset_properties_values_parking_place1)", "\(asset_properties_values_parking_place2)", "\(asset_properties_values_parking_place3)", "\(asset_properties_values_parking_place4)"])
                }
            } catch {
                print(error.localizedDescription)
            }
            database.close()
        }
    }
    
    
    //MARK: - Hàm lấy giá trị trong bảng
    func selectData(date: Date) -> [Location] {
        var DBlocations = [Location]()
        if database.open() {
            
            let queryReadDataElem = """
                                    select * from elem
                                    where date = ?
                                    """
            do {
                let result = try database.executeQuery(queryReadDataElem, values: [date])
                while result.next() {
                    let locationElement = Location(elem: LocationElement(arrivalTime :ArrivalTime(),location: LocationLocation(), locationOrder: 0, metadata: FluffyMetadata()), asset: GetAsset(), createdAt: "")
                    if let iAssetID = result.string(forColumn: "location_assetID"),
                       //                       let ideliveryDate = result.string(forColumn: "date"),
                       let arrivalTime_hour = result.string(forColumn: "arrivalTime_hour"),
                       let arrivalTime_minutes = result.string(forColumn: "arrivalTime_minutes"),
                       let metadata_customer_id = result.string(forColumn: "metadata_customer_id"),
                       let workerRoute_createdAt = result.string(forColumn: "workerRoute_createdAt") {
                        
                        locationElement.elem?.location?.assetID = iAssetID
                        //                        locationElement. = ideliveryDate
                        locationElement.elem?.arrivalTime?.hours = Int(arrivalTime_hour)
                        locationElement.elem?.arrivalTime?.minutes = Int(arrivalTime_minutes)
                        locationElement.elem?.metadata?.customer_id = metadata_customer_id
                        locationElement.createdAt = workerRoute_createdAt
                        
                        DBlocations.append(locationElement)
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        database.close()
        return DBlocations
    }
    
    func selectDataAsset(ilocation: Location) -> GetAsset? {
//        var arrGetAsset = [GetAsset]()
        
        if database.open() {
            
            
            let queryReadDataAsset = """
                                    select * from asset
                                    where id  = ?
                                    """
            
            do {
                let result = try database.executeQuery(queryReadDataAsset, values: [ilocation.elem?.location?.assetID ?? ""] )
                while result.next() {
                    let dbGetAsset = GetAsset(properties: PropertiesDetail(updatedAt: "", values: ValuesDetail(customer_location: [], kyokyusetsubi_code: "")))
                    if let iasset = result.string(forColumn: "id"),
                       let address = result.string(forColumn: "properties_values_address"),
                       let nameCustomer = result.string(forColumn: "properties_valuse_customer_name"),
                       let gasLocation1 = result.string(forColumn: "properties_values_gas_location1"),
                       let gasLocation2 = result.string(forColumn: "properties_values_gas_location2"),
                       let gasLocation3 = result.string(forColumn: "properties_values_gas_location3"),
                       let gasLocation4 = result.string(forColumn: "properties_values_gas_location4"),
                       let parkingPlace1 = result.string(forColumn: "properties_values_parking_place1"),
                       let parkingPlace2 = result.string(forColumn: "properties_values_parking_place2"),
                       let parkingPlace3 = result.string(forColumn: "properties_values_parking_place3"),
                       let parkingPlace4 = result.string(forColumn: "properties_values_parking_place4") {
                        
                        dbGetAsset.id = iasset
                        dbGetAsset.properties?.values.address = address
                        dbGetAsset.properties?.values.customer_name = nameCustomer
                        dbGetAsset.properties?.values.gas_location1 = gasLocation1
                        dbGetAsset.properties?.values.gas_location2 = gasLocation2
                        dbGetAsset.properties?.values.gas_location3 = gasLocation3
                        dbGetAsset.properties?.values.gas_location4 = gasLocation4
                        dbGetAsset.properties?.values.parking_place1 = parkingPlace1
                        dbGetAsset.properties?.values.parking_place2 = parkingPlace2
                        dbGetAsset.properties?.values.parking_place3 = parkingPlace3
                        dbGetAsset.properties?.values.parking_place4 = parkingPlace4
                    }
                    return dbGetAsset
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        database.close()
        return nil
    }
    
    func selectedImageInDB(urlImage: String ) -> UIImage? {
        let image = DBLocation.shared.selectedImageInDB(urlImage: urlImage.md5() + ".png")
        return image
    }
    
}


