//
//  PatchDeliveryStatus.swift
//  Gas
//
//  Created by Vuong The Vu on 15/02/2023.
//

import Foundation


// MARK: - Welcome
class PatchDeliveryStatus: Decodable {
    var etag: String?
    var updatedAt: String?
    var values: Values?
}

// MARK: - Values
class Values: Decodable {
    var address: String?
    var customer_location: [Double]?
    var customer_name: String?
    var display_data: DisplayDataPatch?
    var gas_location1: String?
    var gas_location2: String?
    var gas_location3: String?
    var gas_location4: String?
    var kyokyusetsubi_code: String?
    var location: LocationPatch?
    var notes: String?
//    var operators: [JSONAny]?
    var parking_place1: String?
    var parkingPlace2: String?
    var parkingPlace3: String?
    var parkingPlace4: String?
//    var  timeWindow: JSONNull?
    var total_cylinder_count: Int?
    var vehicleLimit: Int?
//    var workableDay: [JSONAny]?
    
    
    
    
}

// MARK: - DisplayData
class DisplayDataPatch: Decodable {
    let delivery_history: [String: String]
}




// MARK: - Location
class LocationPatch: Decodable {
    let coordinates: [Double]?
    let type: String?
    
    init(coordinates: [Double]?, type: String?) {
        self.coordinates = coordinates
        self.type = type
    }
}








