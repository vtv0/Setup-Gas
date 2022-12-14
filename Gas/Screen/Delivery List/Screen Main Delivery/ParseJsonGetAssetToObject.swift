//
//  ParseJsonGetAssetToStruct.swift
//  Gas
//
//  Created by Vuong The Vu on 31/10/2022.
//

import UIKit

class GetAsset: NSObject, Decodable {
    var assetModelID: Int?
    var createdAt: String?
    var enabled: Bool?
    var geoloc : GeolocDetail?
    var id: String?
    var metedata: String?
    var name: String?
    var properties: PropertiesDetail?
    var tenantID: Int?
    var updatedAt: String?
    var version: Int?
    var vendorThingID: String?
    
    init(assetModelID: Int? = nil, createdAt: String? = nil, enabled: Bool? = nil, geoloc: GeolocDetail? = nil, id: String? = nil, metedata: String? = nil, name: String? = nil, properties: PropertiesDetail? = nil, tenantID: Int? = nil, updatedAt: String? = nil, version: Int? = nil, vendorThingID: String? = nil) {
        self.assetModelID = assetModelID
        self.createdAt = createdAt
        self.enabled = enabled
        self.geoloc = geoloc
        self.id = id
        self.metedata = metedata
        self.name = name
        self.properties = properties
        self.tenantID = tenantID
        self.updatedAt = updatedAt
        self.version = version
        self.vendorThingID = vendorThingID
    }
}
class PropertiesDetail: Decodable {
    //var etag: Int?
    var updatedAt: String
    var values: ValuesDetail
    
    init(updatedAt: String, values: ValuesDetail) {
        self.updatedAt = updatedAt
        self.values = values
    }
}
class ValuesDetail: Decodable {
    var address: String?
    var customer_location: [Double]
    var customer_name: String?
    var display_data: Display_dataDetail
    var gas_location1: String?
    var gas_location2: String?
    var gas_location3: String?
    var gas_location4: String?
    var kyokyusetsubi_code: String
    var location: LocationDetail?
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
    
    init(address: String? = nil, customer_location: [Double], customer_name: String? = nil, display_data: Display_dataDetail, gas_location1: String? = nil, gas_location2: String? = nil, gas_location3: String? = nil, gas_location4: String? = nil, kyokyusetsubi_code: String, location: LocationDetail? = nil, notes: String? = nil, operators: [String]? = nil, parking_place1: String? = nil, parking_place2: String? = nil, parking_place3: String? = nil, parking_place4: String? = nil, total_cylinder_count: Int? = nil, vehicle_limit: Int? = nil, parking_location: [Double]? = nil) {
        self.address = address
        self.customer_location = customer_location
        self.customer_name = customer_name
        self.display_data = display_data
        self.gas_location1 = gas_location1
        self.gas_location2 = gas_location2
        self.gas_location3 = gas_location3
        self.gas_location4 = gas_location4
        self.kyokyusetsubi_code = kyokyusetsubi_code
        self.location = location
        self.notes = notes
        self.operators = operators
        self.parking_place1 = parking_place1
        self.parking_place2 = parking_place2
        self.parking_place3 = parking_place3
        self.parking_place4 = parking_place4
        self.total_cylinder_count = total_cylinder_count
        self.vehicle_limit = vehicle_limit
        self.parking_location = parking_location
    }
    
    
}
class LocationDetail: Decodable {
    var coordinates: [Double]?
    var type: String?
    init(coordinates: [Double]? = nil, type: String? = nil) {
        self.coordinates = coordinates
        self.type = type
    }
}
class Display_dataDetail: Decodable {
    var delivery_history: Dictionary<String,String>?
    var exclude_firstday: Bool?
    var move_to_firstday: Bool? = false
    var origin_route_id: Int?
    
    init(delivery_history: Dictionary<String, String>? = nil, exclude_firstday: Bool? = nil, origin_route_id: Int? = nil, move_to_firstday: Bool? = false) {
        self.delivery_history = delivery_history
        self.exclude_firstday = exclude_firstday
        self.origin_route_id = origin_route_id
        self.move_to_firstday = move_to_firstday
    }
}

class GeolocDetail: Decodable {
    var coordinates : [Double]?
    var type: String?
    init(coordinates: [Double]? = nil, type: String? = nil) {
        self.coordinates = coordinates
        self.type = type
    }
}


