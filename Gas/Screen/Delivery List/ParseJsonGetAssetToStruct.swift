//
//  ParseJsonGetAssetToStruct.swift
//  Gas
//
//  Created by Vuong The Vu on 31/10/2022.
//

import Foundation

struct GetAsset: Decodable {
    var assetModelID : Int
    var createdAt: String?
    var enabled: Bool
    var geoloc : GeolocDetail?
    var id: String?
    var metedata: String?
    var name: String?
    var properties: PropertiesDetail?
    var tenantID: Int?
    var updatedAt: String?
    var version: Int?
    var vendorThingID: String?
}
struct PropertiesDetail: Decodable {
    var etag: Int?
    var updatedAt: Date?
    var values: ValuesDetail?
}
struct ValuesDetail: Decodable {
    var address: String?
    var customer_location: [Float]
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
    var workable_day: [String?]
    
    
    
}
struct LocationDetail: Decodable {
    var coordinates: [Float]?
    var type: String?
}
struct Display_dataDetail: Decodable {
    var delivery_history: Dictionary<String,String>?
    var exclude_firstday: Bool?
    var origin_route_id: Int?
}

struct GeolocDetail: Decodable {
    var coordinates : [Float]
    var type: String?
}


