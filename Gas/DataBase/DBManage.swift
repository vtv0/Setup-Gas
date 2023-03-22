//
//  DBManage.swift
//  Gas
//
//  Created by Vuong The Vu on 02/03/2023.
//

import Foundation



//MARK: -
class LocationRealm: Object {
    @Persisted var elem: LocationElementRealm?
    @Persisted var asset: GetAssetRealm?
}

//MARK: - Object LocationElem

class GetLatestWorkerRouteLocationListInfoRealm: Object {
    var locations: [LocationElementRealm]?
    var workerRoute: WorkerRouteRealm?
}

class WorkerRouteRealm: Object {
    var createdAt: String?
    var id, loadRemain, routeID, totalTimeSEC: Int?
    var workDate: String?
    var workerID, workerVehicleID: Int?
}

class LocationElementRealm: Object {
    var arrivalTime: ArrivalTimeRealm?
    var breakTimeSEC: Int?
    var createdAt: String?
    var latitude: Double?
    var loadCapacity, loadSupply: Int?
    var location: LocationLocationRealm?
    var locationID: Int?
    var locationOrder: Int?
    var longitude: Double?
    var metadata: FluffyMetadataRealm?
    var travelTimeSECToNext, waitingTimeSEC, workTimeSEC: Int?
}

class ArrivalTimeRealm: Object {
    var hours, minutes, nanos, seconds: Int?
}

class LocationLocationRealm: Object {
    
    var areaID: Int?
    var comment, createdAt: String?
    var id, importance: Int?
    var latitude: Double?
    var loadConsumeMax, loadConsumeMin: Int?
    var locationType: LocationTypeRealm?
    var longitude: Double?
    var metadata: PurpleMetadataRealm?
    var priority: String?
    var tenantID: Int?
    // var timeWindow: JSONNull?
    var updatedAt: String?
    var workTimeSEC: Int?
    var assetID: String?
    var loadCapacity: Int?
    var normalizedScore: Double?
    var vehicleLimit: Int?
    
    
    enum LocationTypeRealm: String, CaseIterable {
        case customer = "customer"
        case supplier = "supplier"
    }
    
}
class PurpleMetadataRealm: Object {
    var kyokyusetsubiCode: String?
    var display_data: DisplayDataRealm?
    //    var operators: [String?]?
    
    enum CodingKeys: String, CodingKey {
        case kyokyusetsubiCode = "KYOKYUSETSUBI_CODE"
        case display_data = "display_data"
        //        case operators
    }
}

class DisplayDataRealm: Object {
    var delivery_history: [String: String]?
    var origin_route_id: Int?
    var excludeFirstDay: Bool? = false
    var moveToFirstDay: Bool? = false
}

class FluffyMetadataRealm: Object {
    var customer_id, deliverType: String?
    var facility_data: [Facility_data]?
    var optionalDays: Int?
    var optionalLocation: Bool?
    var planID, planned_date, prevDate: String?
}



//MARK: - Object GetAssetRealm
class GetAssetRealm: Object {
    var assetModelID: Int?
    var createdAt: String?
    var enabled: Bool?
    var geoloc: GeolocDetailRealm?
    var id: String?
    var metedata: String?
    var name: String?
    var properties: PropertiesDetailRealm?
    var tenantID: Int?
    var updatedAt: String?
    var version: Int?
    var vendorThingID: String?
    
}

class GeolocDetailRealm: Object {
    var coordinates : [Double]?
    var type: String?
    
}

class PropertiesDetailRealm: Object {
    var updatedAt: String = ""
    var values: ValuesDetailRealm?
    
}

class ValuesDetailRealm: Object {
    var address: String?
    var customer_location: [Double] = []
    var customer_name: String?
    var display_data: Display_dataDetailRealm?
    var gas_location1: String?
    var gas_location2: String?
    var gas_location3: String?
    var gas_location4: String?
    var kyokyusetsubi_code: String?
    var location: LocationDetailRealm?
    var notes: String?
    var operators: [String]?
    var parking_place1: String?
    var parking_place2: String?
    var parking_place3: String?
    var parking_place4: String?
    //  var time_window: JSONNull
    var total_cylinder_count: Int?
    var vehicle_limit: Int?
    var parking_location: [Double]?
}

class Display_dataDetailRealm: Object {
    var delivery_history: Dictionary<String,String>?
    var exclude_firstday: Bool?
    var move_to_firstday: Bool? = false
    var origin_route_id: Int?
}

class LocationDetailRealm: Object {
    var coordinates: [Double]?
    var type: String?
}


// khoi tao DB
class DBManage {
    private let dataBaseElem: Realm
    
    static let shareInstance = DBManage()
    
    // ham khoi tao
    private init() {
        dataBaseElem = try! Realm()
        
//        let config = Realm.Configuration(
//            schemaVersion: 1,
//            migrationBlock: { migation, oldSchemaVersion in
//                if oldSchemaVersion < 1 { }
//
//            }
//        )
//        Realm.Configuration.defaultConfiguration = config
        
    }
    
    
    // ham lay toan bo Data trong Realm
    func getDataFromDB() -> Results<GetLatestWorkerRouteLocationListInfoRealm> {
        let result = dataBaseElem.objects(GetLatestWorkerRouteLocationListInfoRealm.self)
        return result
    }
    
    
    // ham them du lieu
    func addData(object: GetLatestWorkerRouteLocationListInfoRealm) {
        try! dataBaseElem.write {
            
            dataBaseElem.add(object)
            
            print("them du lieu ok")
        }
    }
    
    
    
    
    
}
