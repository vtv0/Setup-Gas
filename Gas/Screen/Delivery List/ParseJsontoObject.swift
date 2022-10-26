//
//  ParseJsontoObject.swift
//  Gas
//
//  Created by Vuong The Vu on 25/10/2022.
//

import Foundation

// MARK: - Welcome
struct GetLatestWorkerRouteLocationListInfo: Decodable {
    let locations: [LocationElement]
    let workerRoute: WorkerRoute
}

// MARK: - LocationElement
struct LocationElement: Decodable {
    let arrivalTime: Time
    let breakTimeSEC: Int
    let createdAt: String
    let latitude: Double
    let loadCapacity, loadSupply: Int
    let location: LocationLocation?
    let locationID, locationOrder: Int
    let longitude: Double
    let metadata: FluffyMetadata
    let timeWindow: [TimeWindow]?
    let travelTimeSECToNext, waitingTimeSEC, workTimeSEC: Int

    enum CodingKeys: String, CodingKey {
        case arrivalTime
        case breakTimeSEC = "breakTimeSec"
        case createdAt, latitude, loadCapacity, loadSupply, location, locationID, locationOrder, longitude, metadata, timeWindow
        case travelTimeSECToNext = "travelTimeSecToNext"
        case waitingTimeSEC = "waitingTimeSec"
        case workTimeSEC = "workTimeSec"
    }
}

// MARK: - Time
struct Time: Decodable {
    let hours, minutes, nanos, seconds: Int
}

// MARK: - LocationLocation
struct LocationLocation: Decodable {
    let areaID: Int
    let comment, createdAt: String
    let id, importance: Int
    let latitude: Double
    let loadConsumeMax, loadConsumeMin: Int
    let locationType: LocationType
    let longitude: Double
    let metadata: PurpleMetadata
    let priority: String?
    let tenantID: Int
    let timeWindow: [TimeWindow]?
    let updatedAt: String
    let workTimeSEC: Int
    let assetID: String?
    let loadCapacity: Int?
    let normalizedScore: Double?
    let vehicleLimit: Int?

    enum CodingKeys: String, CodingKey {
        case areaID, comment, createdAt, id, importance, latitude, loadConsumeMax, loadConsumeMin, locationType, longitude, metadata, priority, tenantID, timeWindow, updatedAt
        case workTimeSEC = "workTimeSec"
        case assetID, loadCapacity, normalizedScore, vehicleLimit
    }
}

enum LocationType: String, Decodable {
    case customer = "customer"
    case supplier = "supplier"
}

// MARK: - PurpleMetadata
struct PurpleMetadata: Decodable {
    let kyokyusetsubiCode: String?
    let displayData: DisplayData?
    let operators: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case kyokyusetsubiCode = "KYOKYUSETSUBI_CODE"
        case displayData = "display_data"
        case operators
    }
}

// MARK: - DisplayData
struct DisplayData: Decodable {
    let deliveryHistory: [String: DeliveryHistory]
    let originRouteID: Int?
    let excludeFirstday, moveToFirstday: Bool?

    enum CodingKeys: String, CodingKey {
        case deliveryHistory = "delivery_history"
        case originRouteID = "origin_route_id"
        case excludeFirstday = "exclude_firstday"
        case moveToFirstday = "move_to_firstday"
    }
}

enum DeliveryHistory: String, Decodable {
    case completed = "completed"
    case failed = "failed"
    case halfway = "halfway"
    case inprogress = "inprogress"
    case waiting = "waiting"
}

enum Priority: String, Decodable {
    case normal = "normal"
    case priorityOptional = "optional"
}

// MARK: - TimeWindow
struct TimeWindow: Decodable {
    let endTime, startTime: Time
}

// MARK: - FluffyMetadata
struct FluffyMetadata: Decodable {
    let customerID, deliverType: String?
    let facilityData: [FacilityDatum]?
    let optionalDays: Int?
    let optionalLocation: Bool?
    let planID, plannedDate, prevDate: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case deliverType = "deliver_type"
        case facilityData = "facility_data"
        case optionalDays = "optional_days"
        case optionalLocation = "optional_location"
        case planID = "plan_id"
        case plannedDate = "planned_date"
        case prevDate = "prev_date"
    }
}

// MARK: - FacilityDatum
struct FacilityDatum: Decodable {
    let count, type: Int
}

// MARK: - WorkerRoute
struct WorkerRoute: Decodable {
    let createdAt: String
    let id, loadRemain, routeID, totalTimeSEC: Int
    let workDate: String
    let workerID, workerVehicleID: Int

    enum CodingKeys: String, CodingKey {
        case createdAt, id, loadRemain, routeID
        case totalTimeSEC = "totalTimeSec"
        case workDate, workerID, workerVehicleID
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Decodable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Decodable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

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
