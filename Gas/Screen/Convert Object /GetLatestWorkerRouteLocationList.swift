//
//  ParseJsontoObject.swift
//  Gas
//
//  Created by Vuong The Vu on 25/10/2022.

import UIKit

class Location: NSObject, NSCopying {
    var type: LocationType {
        if elem?.location?.assetID == nil {
            return .supplier
        }
        return .customer
    }
    var elem: LocationElement?
    var asset: GetAsset?
    
    init( elem: LocationElement?, asset: GetAsset?) { //type: LocationType,
        //    self.type = type
        self.elem = elem
        self.asset = asset
    }
    
    enum LocationType: String, Codable, CaseIterable {
        case customer = "customer"
        case supplier = "supplier"
    }
    
    // clone Location
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Location(elem: LocationElement(locationOrder: 0), asset: GetAsset())
        return copy
    }
    
}

// MARK: - GetLatestWorkerRouteLocationListInfo
class GetLatestWorkerRouteLocationListInfo: NSObject, Decodable, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GetLatestWorkerRouteLocationListInfo()
        return copy
    }
    
    var locations: [LocationElement]?
    var workerRoute: WorkerRoute?
    
    init(locations: [LocationElement]? = nil, workerRoute: WorkerRoute? = nil) {
        self.locations = locations
        self.workerRoute = workerRoute
    }
}

// MARK: - LocationElement
class LocationElement: NSObject, Decodable {
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
   
    
    init(arrivalTime: ArrivalTime? = nil, breakTimeSEC: Int? = nil, createdAt: String? = nil, latitude: Double? = nil, loadCapacity: Int? = nil, loadSupply: Int? = nil, location: LocationLocation? = nil, locationID: Int? = nil, locationOrder: Int, longitude: Double? = nil, metadata: FluffyMetadata? = nil, travelTimeSECToNext: Int? = nil, waitingTimeSEC: Int? = nil, workTimeSEC: Int? = nil) {
        self.arrivalTime = arrivalTime
        self.breakTimeSEC = breakTimeSEC
        self.createdAt = createdAt
        self.latitude = latitude
        self.loadCapacity = loadCapacity
        self.loadSupply = loadSupply
        self.location = location
        self.locationID = locationID
        self.locationOrder = locationOrder
        self.longitude = longitude
        self.metadata = metadata
        self.travelTimeSECToNext = travelTimeSECToNext
        self.waitingTimeSEC = waitingTimeSEC
        self.workTimeSEC = workTimeSEC
    }
    
}

// MARK: - ArrivalTime
class ArrivalTime: NSObject, Decodable {
    var hours, minutes, nanos, seconds: Int?
    init(hours: Int? = nil, minutes: Int? = nil, nanos: Int? = nil, seconds: Int? = nil) {
        self.hours = hours
        self.minutes = minutes
        self.nanos = nanos
        self.seconds = seconds
    }
}

// MARK: - LocationLocation
class LocationLocation: NSObject, Decodable {
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
    
    
    enum LocationType: String, Codable, CaseIterable {
        case customer = "customer"
        case supplier = "supplier"
    }
    
    init(areaID: Int? = nil, comment: String? = nil, createdAt: String? = nil, id: Int? = nil, importance: Int? = nil, latitude: Double? = nil, loadConsumeMax: Int? = nil, loadConsumeMin: Int? = nil, locationType: LocationType? = nil, longitude: Double? = nil, metadata: PurpleMetadata? = nil, priority: String? = nil, tenantID: Int? = nil, updatedAt: String? = nil, workTimeSEC: Int? = nil, assetID: String? = nil, loadCapacity: Int? = nil, normalizedScore: Double? = nil, vehicleLimit: Int? = nil) {
        self.areaID = areaID
        self.comment = comment
        self.createdAt = createdAt
        self.id = id
        self.importance = importance
        self.latitude = latitude
        self.loadConsumeMax = loadConsumeMax
        self.loadConsumeMin = loadConsumeMin
        self.locationType = locationType
        self.longitude = longitude
        self.metadata = metadata
        self.priority = priority
        self.tenantID = tenantID
        self.updatedAt = updatedAt
        self.workTimeSEC = workTimeSEC
        self.assetID = assetID
        self.loadCapacity = loadCapacity
        self.normalizedScore = normalizedScore
        self.vehicleLimit = vehicleLimit
    }
}



// MARK: - PurpleMetadata
class PurpleMetadata: NSObject, Codable {
    var kyokyusetsubiCode: String?
    var display_data: DisplayData?
    var operators: [String?]?
    
    enum CodingKeys: String, CodingKey {
        case kyokyusetsubiCode = "KYOKYUSETSUBI_CODE"
        case display_data = "display_data"
        case operators
    }
    
    init(kyokyusetsubiCode: String? = nil, display_data: DisplayData, operators: [String?]? = nil) {
        self.kyokyusetsubiCode = kyokyusetsubiCode
        self.display_data = display_data
        self.operators = operators
    }
}

// MARK: - DisplayData
class DisplayData: NSObject, Codable {
    var delivery_history: [String: String]?
    var origin_route_id: Int?
    var excludeFirstDay: Bool? = false
    var moveToFirstDay: Bool? = false
    
    init(delivery_history: [String : String]? = nil, origin_route_id: Int? = nil, excludeFirstDay: Bool? = false, moveToFirstDay: Bool? = false) {
        self.delivery_history = delivery_history
        self.origin_route_id = origin_route_id
        self.excludeFirstDay = excludeFirstDay
        self.moveToFirstDay = moveToFirstDay
    }
    
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
        class DataHistory {
            var date: String
            var status: String
            init(date: String, status: String) {
                self.date = date
                self.status = status
            }
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
            return true
        }
        if let status = arr.last?.status {
            return DeliveryHistory.init(rawValue: status) ?? .waiting
        }
        
        return .waiting
    }
    
}


// MARK: - FluffyMetadata
class FluffyMetadata: NSObject, Decodable {
    var customer_id, deliverType: String?
    var facility_data: [Facility_data]?
    var optionalDays: Int?
    var optionalLocation: Bool?
    var planID, planned_date, prevDate: String?
    
    init(customer_id: String? = nil, deliverType: String? = nil, facility_data: [Facility_data]? = nil, optionalDays: Int? = nil, optionalLocation: Bool? = nil, planID: String? = nil, planned_date: String? = nil, prevDate: String? = nil) {
        self.customer_id = customer_id
        self.deliverType = deliverType
        self.facility_data = facility_data
        self.optionalDays = optionalDays
        self.optionalLocation = optionalLocation
        self.planID = planID
        self.planned_date = planned_date
        self.prevDate = prevDate
    }
}

// MARK: - FacilityDatum
class Facility_data: NSObject, Codable {
    var count, type: Int?
    
    enum Count: Int {
        case kg50 = 50
        case kg30 = 30
        case kg25 = 25
        case kg20 = 20
        case kgOther = 0
    }
    
    init(count: Int? = nil, type: Int? = nil) {
        self.count = count
        self.type = type
    }
}

// MARK: - WorkerRoute
class WorkerRoute: NSObject, Codable {
    var createdAt: String?
    var id, loadRemain, routeID, totalTimeSEC: Int?
    var workDate: String?
    var workerID, workerVehicleID: Int?
    
    init(createdAt: String? = nil, id: Int? = nil, loadRemain: Int? = nil, routeID: Int? = nil, totalTimeSEC: Int? = nil, workDate: String? = nil, workerID: Int? = nil, workerVehicleID: Int? = nil) {
        self.createdAt = createdAt
        self.id = id
        self.loadRemain = loadRemain
        self.routeID = routeID
        self.totalTimeSEC = totalTimeSEC
        self.workDate = workDate
        self.workerID = workerID
        self.workerVehicleID = workerVehicleID
    }
    
    enum CodingKeys: String, CodingKey {
        case createdAt, id, loadRemain, routeID
        case totalTimeSEC = "totalTimeSec"
        case workDate, workerID, workerVehicleID
    }
    
}

