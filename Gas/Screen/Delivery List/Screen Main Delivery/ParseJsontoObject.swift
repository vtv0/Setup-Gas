//
//  ParseJsontoObject.swift
//  Gas
//
//  Created by Vuong The Vu on 25/10/2022.
//
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//  let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import UIKit


class Location {
    var type: LocationType
    var elem: LocationElement?
    var asset: GetAsset?
    
    init(type: LocationType, elem: LocationElement?, asset: GetAsset?) {
        self.type = type
        self.elem = elem 
        self.asset = asset
    }

    enum LocationType: String, Codable, CaseIterable {
        case customer = "customer"
        case supplier = "supplier"
    }
}



// MARK: - GetLatestWorkerRouteLocationListInfo
struct GetLatestWorkerRouteLocationListInfo: Decodable {
    var locations: [LocationElement]?
    var workerRoute: WorkerRoute?
}

// MARK: - LocationElement
struct LocationElement: Decodable {  // CustomStringConvertible
//    var description: String {
//        return "locationOrder: \(locationOrder)"
//    }
    
    var arrivalTime: ArrivalTime?
    var breakTimeSEC: Int?
    var createdAt: String?
    var latitude: Double?
    var loadCapacity, loadSupply: Int?
    var location: LocationLocation?
    var locationID: Int?
    var locationOrder: Int
    var longitude: Double?
    var metadata: FluffyMetadata?
    var travelTimeSECToNext, waitingTimeSEC, workTimeSEC: Int?
    //var timeWindow: JSONNull?
    
    //    enum CodingKeys: String, CodingKey {
    //        case arrivalTime
    //        case breakTimeSEC = "breakTimeSec"
    //        case createdAt, latitude, loadCapacity, loadSupply, location, locationID, locationOrder, longitude, metadata, timeWindow
    //        case travelTimeSECToNext = "travelTimeSecToNext"
    //        case waitingTimeSEC = "waitingTimeSec"
    //        case workTimeSEC = "workTimeSec"
    //    }
}

// MARK: - ArrivalTime
struct ArrivalTime: Decodable {
    var hours, minutes, nanos, seconds: Int?
}

// MARK: - LocationLocation
struct LocationLocation: Decodable {
    var areaID: Int?
    var comment, createdAt: String?
    var id, importance: Int?
    var latitude: Double?
    var loadConsumeMax, loadConsumeMin: Int?
    var locationType: LocationType?
    var longitude: Double?
    var metadata: PurpleMetadata?
    var priority: String?
    var tenantID: Int?
    // var timeWindow: JSONNull?
    var updatedAt: String?
    var workTimeSEC: Int?
    var assetID: String?
    var loadCapacity: Int?
    var normalizedScore: Double?
    var vehicleLimit: Int?
    
//    func status() -> LocationType? {
//        if locationType == "supplier" {
//            
//        }
//        
//        return .customer
//    }
    enum LocationType: String, Codable, CaseIterable {
        case customer = "customer"
        case supplier = "supplier"
    }
    
//    enum MyCode : String, CaseIterable {
//
//        case one   = "uno"
//        case two   = "dos"
//        case three = "tres"
//
//        static func withLabel(_ label: String) -> MyCode? {
//            return self.allCases.first{ "\($0)" == label }
//        }
//    }
    //    enum CodingKeys: String, CodingKey {
    //        case areaID, comment, createdAt, id, importance, latitude, loadConsumeMax, loadConsumeMin, locationType, longitude, metadata, priority, tenantID, timeWindow, updatedAt
    //        case workTimeSEC = "workTimeSec"
    //        case assetID, loadCapacity, normalizedScore, vehicleLimit
    //    }
}



// MARK: - PurpleMetadata
struct PurpleMetadata: Codable {
    var kyokyusetsubiCode: String?
    var displayData: DisplayData?
    var operators: [String?]?
    
    enum CodingKeys: String, CodingKey {
        case kyokyusetsubiCode = "KYOKYUSETSUBI_CODE"
        case displayData = "display_data"
        case operators
    }
}

// MARK: - DisplayData
struct DisplayData: Codable {
    var delivery_history: [String: String]?
    var excludeFirstday: Bool?
    var originRouteID: Int?
    var moveToFirstday: Bool?
    
    enum DeliveryHistory: String, Codable {
        case completed = "completed"
        case failed = "failed"
        case halfway = "halfway"
        case inprogress = "inprogress"
        case waiting = "waiting"  //chua giao
    }
    
    
    func valueDeliveryHistory() -> DeliveryHistory {
        var arrStringDate: [String] = []
        if let arrKey = delivery_history?.keys {
            for i: String in arrKey {
                arrStringDate.append(i)
            }
        }
        struct DataHistory {
            var date: String
            var status: String
        }
        var arr: [DataHistory] = []
        
        delivery_history?.keys.forEach({ key in
            if let status = delivery_history?[key] {
                let data = DataHistory.init(date: key, status: status)
                arr.append(data)
            }
        })
        arr.sort{ h1, h2 in
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm"
            if let d1 = df.date(from: h1.date), let d2 = df.date(from: h2.date) {
                return d1 < d2
            }
            
            return false
        }
        if let status = arr.last?.status {
            return DeliveryHistory.init(rawValue: status) ?? .waiting
        }
        
        return .waiting
        
        //        deliveryHistory?.keys.forEach { i in
        //            arrStringDate.append(i)
        //            print("qqqqqqqqqqqqqqqqqqq:\(i)")
        //        }
        //        let dateFormatter = DateFormatter()
        //        //dateFormatter.timeZone = TimeZone(identifier: "UTC")
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        //        let dateObjects: [Date] = arrStringDate.compactMap{ dateFormatter.date(from: $0) } //loc cac phan tu nil trong [String] va chuyen [String] -> [Date]
        //        var stringKey: String = String.init()
        //        let recentDays = dateObjects.sorted(by: { $0.compare($1) == .orderedDescending }) //sap xep [Date]
        //        if let mostRecentDay = recentDays.first{
        //       //     print(mostRecentDay)  // lay ra phan tu Date gan day nhat
        //
        //            let today = mostRecentDay
        //            let formatter1 = DateFormatter()
        //            formatter1.timeZone = TimeZone(identifier: "UTC")
        //            formatter1.dateFormat = "yyyy-MM-dd HH:mm"
        //            stringKey = formatter1.string(from: today) //chuyen Date -> String
        //
        //
        //        }
        //        print("\(stringKey)::>\(delivery_history?["\(stringKey)"])")
        //        return delivery_history?["\(stringKey )"] ?? ""
    }
    
}

//struct DeliveryHistory : Decodable {
//    statusValue : String?
//}



//enum Priority: String, Codable {
//    case normal = "normal"
//    case priorityOptional = "optional"
//}

// MARK: - FluffyMetadata
struct FluffyMetadata: Decodable {
    var customer_id, deliverType: String?
    var facility_data: [Facility_data]?
    var optionalDays: Int?
    var optionalLocation: Bool?
    var planID, planned_date, prevDate: String?
    
    //    enum CodingKeys: String, CodingKey {
    //        case customerID = "customer_id"
    //        case deliverType = "deliver_type"
    //        case facilityData = "facility_data"
    //        case optionalDays = "optional_days"
    //        case optionalLocation = "optional_location"
    //        case planID = "plan_id"
    //        case plannedDate = "planned_date"
    //        case prevDate = "prev_date"
    //    }
}

// MARK: - FacilityDatum
struct Facility_data: Codable {
    var count, type: Int?
}

// MARK: - WorkerRoute
struct WorkerRoute: Codable {
    var createdAt: String?
    var id, loadRemain, routeID, totalTimeSEC: Int?
    var workDate: String?
    var workerID, workerVehicleID: Int?
    
    enum CodingKeys: String, CodingKey {
        case createdAt, id, loadRemain, routeID
        case totalTimeSEC = "totalTimeSec"
        case workDate, workerID, workerVehicleID
    }
}

// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        // No-op
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}

//class JSONCodingKey: CodingKey {
//    let key: String
//
//    required init?(intValue: Int) {
//        return nil
//    }
//
//    required init?(stringValue: String) {
//        key = stringValue
//    }
//
//    var intValue: Int? {
//        return nil
//    }
//
//    var stringValue: String {
//        return key
//    }
//}

//class JSONAny: Codable {
//
//    let value: Any
//
//    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
//        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
//        return DecodingError.typeMismatch(JSONAny.self, context)
//    }
//
//    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
//        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
//        return EncodingError.invalidValue(value, context)
//    }
//
//    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if container.decodeNil() {
//            return JSONNull()
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if let value = try? container.decodeNil() {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer() {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
//        if let value = try? container.decode(Bool.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Double.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(String.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decodeNil(forKey: key) {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
//        var arr: [Any] = []
//        while !container.isAtEnd {
//            let value = try decode(from: &container)
//            arr.append(value)
//        }
//        return arr
//    }
//
//    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
//        var dict = [String: Any]()
//        for key in container.allKeys {
//            let value = try decode(from: &container, forKey: key)
//            dict[key.stringValue] = value
//        }
//        return dict
//    }
//
//    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
//        for value in array {
//            if let value = value as? Bool {
//                try container.encode(value)
//            } else if let value = value as? Int64 {
//                try container.encode(value)
//            } else if let value = value as? Double {
//                try container.encode(value)
//            } else if let value = value as? String {
//                try container.encode(value)
//            } else if value is JSONNull {
//                try container.encodeNil()
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer()
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
//        for (key, value) in dictionary {
//            let key = JSONCodingKey(stringValue: key)!
//            if let value = value as? Bool {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Int64 {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Double {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? String {
//                try container.encode(value, forKey: key)
//            } else if value is JSONNull {
//                try container.encodeNil(forKey: key)
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer(forKey: key)
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
//        if let value = value as? Bool {
//            try container.encode(value)
//        } else if let value = value as? Int64 {
//            try container.encode(value)
//        } else if let value = value as? Double {
//            try container.encode(value)
//        } else if let value = value as? String {
//            try container.encode(value)
//        } else if value is JSONNull {
//            try container.encodeNil()
//        } else {
//            throw encodingError(forValue: value, codingPath: container.codingPath)
//        }
//    }
//
//    public required init(from decoder: Decoder) throws {
//        if var arrayContainer = try? decoder.unkeyedContainer() {
//            self.value = try JSONAny.decodeArray(from: &arrayContainer)
//        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
//            self.value = try JSONAny.decodeDictionary(from: &container)
//        } else {
//            let container = try decoder.singleValueContainer()
//            self.value = try JSONAny.decode(from: container)
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        if let arr = self.value as? [Any] {
//            var container = encoder.unkeyedContainer()
//            try JSONAny.encode(to: &container, array: arr)
//        } else if let dict = self.value as? [String: Any] {
//            var container = encoder.container(keyedBy: JSONCodingKey.self)
//            try JSONAny.encode(to: &container, dictionary: dict)
//        } else {
//            var container = encoder.singleValueContainer()
//            try JSONAny.encode(to: &container, value: self.value)
//        }
//    }
//}

//import UIKit
//
//struct GetLatestWorkerRouteLocationListInfo: Decodable {
//    var locations: [ObjectItem]?
//    var workerRoute : workerRouteDetail
//}
//
//struct ObjectItem : Decodable {
//    var arrivalTime : arrivalTimeDetail?
//    var breakTimeSec: Int
//    var createdAt: String?
//    var latitude : Double
//    var loadCapacity: Int?
//    var loadSupply: Int
//    var location : locationDetail?
//    var locationID: Int
//    var locationOrder : Int
//    var longitude : Double
//    var metadata : metedateDetail
//    var timeWindow : String?
//    var travelTimeSecToNext : Int
//    var waitingTimeSec: Int
//    var workTimeSec: Int
//
//}
//
//struct locationDetail : Decodable {
//    var areaID: Int?
//    var assetID: String?
//    var comment : String?
//    var createdAt : String?
//    var id : Int?
//    var importance : Int?
//    var latitude: Double?
//    var loadCapacity: Int?
//    var loadConsumeMax: Int?
//    var loadConsumeMin: Int?
//    var locationType : String?
//    var longitude: Double?
//    var metadata : metedateDetail?
//    var normalizedScore : Double?
//    var priority: String?
//    var tenantID: Int?
//    var timeWindow: String?
//    var updatedAt: Date?
//    var vehicleLimit : Int?
//    var workTimeSec: Int?
//}
//struct arrivalTimeDetail : Decodable {
//    var hours : Int?
//    var minutes : Int?
//    var nanos : Int?
//    var second : Int?
//
//}
//struct metedateDetail : Decodable {
//    var KYOKYUSETSUBI_CODE : String?
//    var display_data : display_dataDetail?
//    var operators : [String]?
//}
//struct display_dataDetail : Decodable {
//    var delivery_history: DateInfo?
//
//}
//struct DateInfo : Decodable {
//    var dateDetail : String?
//}
//struct workerRouteDetail: Decodable {
//         var  createdAt: String?
//         var  id: Int
//         var loadRemain: Int
//         var  routeID: Int
//         var totalTimeSec: Double
//         var workDate: Date
//         var workerID: Int
//         var workerVehicleID: Int
//}
//
//
//
