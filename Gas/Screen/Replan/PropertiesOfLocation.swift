////
////  PropertiesGetAsset.swift
////  Gas
////
////  Created by Vuong The Vu on 12/12/2022.
////
//
//
//
//import UIKit
//
//
//class Location {
//    var elem: LocationElement?
//    var asset: GetAsset?
//
//    var type: LocationType {
//        if elem?.location?.assetID == nil {
//            return .supplier
//        }
//        return .customer
//    }
//
//    init(elem: LocationElement, asset: GetAsset) {
//        self.elem = elem
//        self.asset = asset
//    }
//    enum LocationType: String, Codable, CaseIterable {
//        case customer = "customer"
//        case supplier = "supplier"
//    }
//
//}
//
//class InformationDelivery {
//    var locations: [LocationElement]?
//    var workerRoute: WorkerRoute?
//    init(locations: [LocationElement]? = nil, workerRoute: WorkerRoute? = nil) {
//        self.locations = locations
//        self.workerRoute = workerRoute
//    }
//}
//
//
////class LocationElement {
////    var arrivalTime: ArrivalTime?
////    var breakTimeSEC: Int?
////    var createdAt: String?
////    var latitude: Double?
////    var loadCapacity, loadSupply: Int?
////    var location: LocationLocation?
////    var locationID: Int?
////    var locationOrder: Int = 0
////    var longitude: Double?
////    var metadata: FluffyMetadata?
////    var travelTimeSECToNext, waitingTimeSEC, workTimeSEC: Int?
////}
////
////class ArrivalTime {
////    var hours, minutes, nanos, seconds: Int?
////
////    init(hours: Int? = nil, minutes: Int? = nil, nanos: Int? = nil, seconds: Int? = nil) {
////        self.hours = hours
////        self.minutes = minutes
////        self.nanos = nanos
////        self.seconds = seconds
////    }
////}
////
////class LocationLocation {
////    var areaID: Int?
////    var comment, createdAt: String?
////    var id, importance: Int?
////    var latitude: Double?
////    var loadConsumeMax, loadConsumeMin: Int?
////    var locationType: LocationType?
////    var longitude: Double?
////    var metadata: PurpleMetadata?
////    var priority: String?
////    var tenantID: Int?
////    // var timeWindow: JSONNull?
////    var updatedAt: String?
////    var workTimeSEC: Int?
////    var assetID: String?
////    var loadCapacity: Int?
////    var normalizedScore: Double?
////    var vehicleLimit: Int?
////
////    init(areaID: Int? = nil, comment: String? = nil, createdAt: String? = nil, id: Int? = nil, importance: Int? = nil, latitude: Double? = nil, loadConsumeMax: Int? = nil, loadConsumeMin: Int? = nil, locationType: LocationType? = nil, longitude: Double? = nil, metadata: PurpleMetadata? = nil, priority: String? = nil, tenantID: Int? = nil, updatedAt: String? = nil, workTimeSEC: Int? = nil, assetID: String? = nil, loadCapacity: Int? = nil, normalizedScore: Double? = nil, vehicleLimit: Int? = nil) {
////        self.areaID = areaID
////        self.comment = comment
////        self.createdAt = createdAt
////        self.id = id
////        self.importance = importance
////        self.latitude = latitude
////        self.loadConsumeMax = loadConsumeMax
////        self.loadConsumeMin = loadConsumeMin
////        self.locationType = locationType
////        self.longitude = longitude
////        self.metadata = metadata
////        self.priority = priority
////        self.tenantID = tenantID
////        self.updatedAt = updatedAt
////        self.workTimeSEC = workTimeSEC
////        self.assetID = assetID
////        self.loadCapacity = loadCapacity
////        self.normalizedScore = normalizedScore
////        self.vehicleLimit = vehicleLimit
////    }
////
////    enum LocationType: String, Codable, CaseIterable {
////        case customer = "customer"
////        case supplier = "supplier"
////    }
////}
////
////class PurpleMetadata {
////    var kyokyusetsubiCode: String?
////    var displayData: DisplayData?
////    var operators: [String?]?
////
////    init(kyokyusetsubiCode: String? = nil, displayData: DisplayData? = nil, operators: [String?]? = nil) {
////        self.kyokyusetsubiCode = kyokyusetsubiCode
////        self.displayData = displayData
////        self.operators = operators
////    }
////
////    enum CodingKeys: String, CodingKey {
////        case kyokyusetsubiCode = "KYOKYUSETSUBI_CODE"
////        case displayData = "display_data"
////        case operators
////    }
////}
////
////class DisplayData {
////    var delivery_history: [String: String]?
////    var excludeFirstday: Bool?
////    var originRouteID: Int?
////    var moveToFirstday: Bool?
////
////    init(delivery_history: [String : String]? = nil, excludeFirstday: Bool? = nil, originRouteID: Int? = nil, moveToFirstday: Bool? = nil) {
////        self.delivery_history = delivery_history
////        self.excludeFirstday = excludeFirstday
////        self.originRouteID = originRouteID
////        self.moveToFirstday = moveToFirstday
////    }
////
////    enum DeliveryHistory: String, Codable {
////        case completed = "completed"
////        case failed = "failed"
////        case halfway = "halfway"
////        case inprogress = "inprogress"
////        case waiting = "waiting"  //chua giao
////    }
////
////
////    func valueDeliveryHistory() -> DeliveryHistory {
////        var arrStringDate: [String] = []
////        if let arrKey = delivery_history?.keys {
////            for i: String in arrKey {
////                arrStringDate.append(i)
////            }
////        }
////        struct DataHistory {
////            var date: String
////            var status: String
////        }
////        var arr: [DataHistory] = []
////
////        delivery_history?.keys.forEach({ key in
////            if let status = delivery_history?[key] {
////                let data = DataHistory.init(date: key, status: status)
////                arr.append(data)
////            }
////        })
////        arr.sort{ h1, h2 in
////            let df = DateFormatter()
////            df.dateFormat = "yyyy-MM-dd HH:mm"
////            if let d1 = df.date(from: h1.date), let d2 = df.date(from: h2.date) {
////                return d1 < d2
////            }
////
////            return false
////        }
////        if let status = arr.last?.status {
////            return DeliveryHistory.init(rawValue: status) ?? .waiting
////        }
////
////        return .waiting
////
////    }
////
////}
////
////class FluffyMetadata {
////    var customer_id, deliverType: String?
////    var facility_data: [Facility_data]?
////    var optionalDays: Int?
////    var optionalLocation: Bool?
////    var planID, planned_date, prevDate: String?
////
////    init(customer_id: String? = nil, deliverType: String? = nil, facility_data: [Facility_data]? = nil, optionalDays: Int? = nil, optionalLocation: Bool? = nil, planID: String? = nil, planned_date: String? = nil, prevDate: String? = nil) {
////        self.customer_id = customer_id
////        self.deliverType = deliverType
////        self.facility_data = facility_data
////        self.optionalDays = optionalDays
////        self.optionalLocation = optionalLocation
////        self.planID = planID
////        self.planned_date = planned_date
////        self.prevDate = prevDate
////    }
////
////}
////
////class Facility_data {
////    var count, type: Int?
////
////    init(count: Int? = nil, type: Int? = nil) {
////        self.count = count
////        self.type = type
////    }
////}
////
////
////class WorkerRoute {
////    var createdAt: String?
////    var id, loadRemain, routeID, totalTimeSEC: Int?
////    var workDate: String?
////    var workerID, workerVehicleID: Int?
////
////    init(createdAt: String? = nil, id: Int? = nil, loadRemain: Int? = nil, routeID: Int? = nil, totalTimeSEC: Int? = nil, workDate: String? = nil, workerID: Int? = nil, workerVehicleID: Int? = nil) {
////        self.createdAt = createdAt
////        self.id = id
////        self.loadRemain = loadRemain
////        self.routeID = routeID
////        self.totalTimeSEC = totalTimeSEC
////        self.workDate = workDate
////        self.workerID = workerID
////        self.workerVehicleID = workerVehicleID
////    }
////
////    enum CodingKeys: String, CodingKey {
////        case createdAt, id, loadRemain, routeID
////        case totalTimeSEC = "totalTimeSec"
////        case workDate, workerID, workerVehicleID
////    }
////
////}
