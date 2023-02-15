////
////  PatchDeliveryStatus.swift
////  Gas
////
////  Created by Vuong The Vu on 15/02/2023.
////
//
//import Foundation
//
//
//// MARK: - Welcome
//class PatchDeliveryStatus: Codable {
//    let etag, updatedAt: String?
//    let values: Values?
//
//    init(etag: String?, updatedAt: String?, values: Values?) {
//        self.etag = etag
//        self.updatedAt = updatedAt
//        self.values = values
//    }
//}
//
//// MARK: - Values
//class Values: Codable {
//    let address: String?
//    let customerLocation: [Double]?
//    let customerName: String?
//    let displayData: DisplayData?
//    let gasLocation1: String?
//    let gasLocation2: String?
//    let gasLocation3, gasLocation4, kyokyusetsubiCode: String?
//    let location: Location?
//    let notes: String?
//    let operators: [JSONAny]?
//    let parkingPlace1, parkingPlace2, parkingPlace3, parkingPlace4: String?
//    let timeWindow: JSONNull?
//    let totalCylinderCount, vehicleLimit: Int?
//    let workableDay: [JSONAny]?
//
//    enum CodingKeys: String, CodingKey {
//        case address
//        case customerLocation
//        case customerName
//        case displayData
//        case gasLocation1
//        case gasLocation2
//        case gasLocation3
//        case gasLocation4
//        case kyokyusetsubiCode
//        case location, notes, operators
//        case parkingPlace1
//        case parkingPlace2
//        case parkingPlace3
//        case parkingPlace4
//        case timeWindow
//        case totalCylinderCount
//        case vehicleLimit
//        case workableDay
//    }
//
//    init(address: String?, customerLocation: [Double]?, customerName: String?, displayData: DisplayData?, gasLocation1: String?, gasLocation2: String?, gasLocation3: String?, gasLocation4: String?, kyokyusetsubiCode: String?, location: Location?, notes: String?, operators: [JSONAny]?, parkingPlace1: String?, parkingPlace2: String?, parkingPlace3: String?, parkingPlace4: String?, timeWindow: JSONNull?, totalCylinderCount: Int?, vehicleLimit: Int?, workableDay: [JSONAny]?) {
//        self.address = address
//        self.customerLocation = customerLocation
//        self.customerName = customerName
//        self.displayData = displayData
//        self.gasLocation1 = gasLocation1
//        self.gasLocation2 = gasLocation2
//        self.gasLocation3 = gasLocation3
//        self.gasLocation4 = gasLocation4
//        self.kyokyusetsubiCode = kyokyusetsubiCode
//        self.location = location
//        self.notes = notes
//        self.operators = operators
//        self.parkingPlace1 = parkingPlace1
//        self.parkingPlace2 = parkingPlace2
//        self.parkingPlace3 = parkingPlace3
//        self.parkingPlace4 = parkingPlace4
//        self.timeWindow = timeWindow
//        self.totalCylinderCount = totalCylinderCount
//        self.vehicleLimit = vehicleLimit
//        self.workableDay = workableDay
//    }
//}
//
//// MARK: - DisplayData
//class DisplayData: Codable {
//    let deliveryHistory: DeliveryHistory?
//
//    enum CodingKeys: String, CodingKey {
//        case deliveryHistory
//    }
//
//    init(deliveryHistory: DeliveryHistory?) {
//        self.deliveryHistory = deliveryHistory
//    }
//}
//
//// MARK: - DeliveryHistory
//class DeliveryHistory: Codable {
//    let the202301121429, the202301121453, the202303151454: String?
//
//    enum CodingKeys: String, CodingKey {
//        case the202301121429
//        case the202301121453
//        case the202303151454
//    }
//
//    init(the202301121429: String?, the202301121453: String?, the202303151454: String?) {
//        self.the202301121429 = the202301121429
//        self.the202301121453 = the202301121453
//        self.the202303151454 = the202303151454
//    }
//}
//
//// MARK: - Location
//class Location: Codable {
//    let coordinates: [Double]?
//    let type: String?
//
//    init(coordinates: [Double]?, type: String?) {
//        self.coordinates = coordinates
//        self.type = type
//    }
//}
//
//// MARK: - Encode/decode helpers
//
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
//
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
//
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
