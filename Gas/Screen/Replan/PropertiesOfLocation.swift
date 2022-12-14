

//  PropertiesGetAsset.swift
//  Gas
//
//  Created by Vuong The Vu on 12/12/2022.




import UIKit


class LocationToObject: NSObject {
    public var elem: LocationElement?
    public var asset: GetAsset?
    
    var type: LocationType {
        if elem?.location?.assetID == nil {
            return .supplier
        }
        return .customer
    }
    
    init(elem: LocationElement, asset: GetAsset) {
        self.elem = elem
        self.asset = asset
    }
    enum LocationType: String, Codable, CaseIterable {
        case customer = "customer"
        case supplier = "supplier"
    }
    
}

class InformationDelivery: NSObject{
    var locations: [LocationElement]?
    var workerRoute: WorkerRouteToObject?
    
    init(locations: [LocationElement]? = nil, workerRoute: WorkerRouteToObject? = nil) {
        self.locations = locations
        self.workerRoute = workerRoute
    }
    
}

// MARK: -LocationElementToObject

class LocationElementToObject: NSObject {
    var arrivalTime: ArrivalTimeToObject?
    var breakTimeSEC: Int?
    var createdAt: String?
    var latitude: Double?
    var loadCapacity, loadSupply: Int?
    var location: LocationLocationToObject?
    var locationID: Int?
    var locationOrder: Int = 0
    var longitude: Double?
    var metadata: FluffyMetadataToObject?
    var travelTimeSECToNext, waitingTimeSEC, workTimeSEC: Int?
    
    init(arrivalTime: ArrivalTimeToObject? = nil, breakTimeSEC: Int? = nil, createdAt: String? = nil, latitude: Double? = nil, loadCapacity: Int? = nil, loadSupply: Int? = nil, location: LocationLocationToObject? = nil, locationID: Int? = nil, locationOrder: Int, longitude: Double? = nil, metadata: FluffyMetadataToObject? = nil, travelTimeSECToNext: Int? = nil, waitingTimeSEC: Int? = nil, workTimeSEC: Int? = nil) {
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

class ArrivalTimeToObject: NSObject {
    var hours, minutes, nanos, seconds: Int?
    
    init(hours: Int? = nil, minutes: Int? = nil, nanos: Int? = nil, seconds: Int? = nil) {
        self.hours = hours
        self.minutes = minutes
        self.nanos = nanos
        self.seconds = seconds
    }
}

class LocationLocationToObject: NSObject {
    var areaID: Int?
    var comment, createdAt: String?
    var id, importance: Int?
    var latitude: Double?
    var loadConsumeMax, loadConsumeMin: Int?
    var locationType: LocationTypeToObject?
    var longitude: Double?
    var metadata: PurpleMetadataToObject?
    var priority: String?
    var tenantID: Int?
    // var timeWindow: JSONNull?
    var updatedAt: String?
    var workTimeSEC: Int?
    var assetID: String?
    var loadCapacity: Int?
    var normalizedScore: Double?
    var vehicleLimit: Int?
    
    init(areaID: Int? = nil, comment: String? = nil, createdAt: String? = nil, id: Int? = nil, importance: Int? = nil, latitude: Double? = nil, loadConsumeMax: Int? = nil, loadConsumeMin: Int? = nil, locationType: LocationTypeToObject? = nil, longitude: Double? = nil, metadata: PurpleMetadataToObject? = nil, priority: String? = nil, tenantID: Int? = nil, updatedAt: String? = nil, workTimeSEC: Int? = nil, assetID: String? = nil, loadCapacity: Int? = nil, normalizedScore: Double? = nil, vehicleLimit: Int? = nil) {
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
    
    enum LocationTypeToObject: String, Codable, CaseIterable {
        case customer = "customer"
        case supplier = "supplier"
    }
}

class PurpleMetadataToObject: NSObject {
    var kyokyusetsubiCode: String?
    var displayData: DisplayDataToObject?
    var operators: [String?]?
    
    init(kyokyusetsubiCode: String? = nil, displayData: DisplayDataToObject? = nil, operators: [String?]? = nil) {
        self.kyokyusetsubiCode = kyokyusetsubiCode
        self.displayData = displayData
        self.operators = operators
    }
    
    enum CodingKeys: String, CodingKey {
        case kyokyusetsubiCode = "KYOKYUSETSUBI_CODE"
        case displayData = "display_data"
        case operators
    }
}

class DisplayDataToObject: NSObject {
    var delivery_history: [String: String]?
    var excludeFirstday: Bool?
    var originRouteID: Int?
    var moveToFirstday: Bool?
    
    init(delivery_history: [String : String]? = nil, excludeFirstday: Bool? = nil, originRouteID: Int? = nil, moveToFirstday: Bool? = nil) {
        self.delivery_history = delivery_history
        self.excludeFirstday = excludeFirstday
        self.originRouteID = originRouteID
        self.moveToFirstday = moveToFirstday
    }
    
    enum DeliveryHistory: String, Codable {
        case completed = "completed"
        case failed = "failed"
        case halfway = "halfway"
        case inprogress = "inprogress"
        case waiting = "waiting"  //chua giao
    }
    
    
    
    
}

class FluffyMetadataToObject: NSObject {
    var customer_id, deliverType: String?
    var facility_data: [Facility_dataToObject]?
    var optionalDays: Int?
    var optionalLocation: Bool?
    var planID, planned_date, prevDate: String?
    
    init(customer_id: String? = nil, deliverType: String? = nil, facility_data: [Facility_dataToObject]? = nil, optionalDays: Int? = nil, optionalLocation: Bool? = nil, planID: String? = nil, planned_date: String? = nil, prevDate: String? = nil) {
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

class Facility_dataToObject: NSObject {
    var count, type: Int?
    
    init(count: Int? = nil, type: Int? = nil) {
        self.count = count
        self.type = type
    }
}


class WorkerRouteToObject: NSObject {
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

// MARK: -GetAssetToObject
class GetAssetToObject: NSObject, Decodable {
    var assetModelID: Int?
    var createdAt: String?
    var enabled: Bool?
    var geoloc : GeolocDetailToObject?
    var id: String?
    var metedata: String?
    var name: String?
    var properties: PropertiesDetailToObject?
    var tenantID: Int?
    var updatedAt: String?
    var version: Int?
    var vendorThingID: String?
    
    
    
    init(assetModelID: Int? = nil, createdAt: String? = nil, enabled: Bool? = nil, geoloc: GeolocDetailToObject? = nil, id: String? = nil, metedata: String? = nil, name: String? = nil, properties: PropertiesDetailToObject? = nil, tenantID: Int? = nil, updatedAt: String? = nil, version: Int? = nil, vendorThingID: String? = nil) {
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
class PropertiesDetailToObject: Decodable {
    //var etag: Int?
    var updatedAt: String
    var values: ValuesDetail
    
    init(updatedAt: String, values: ValuesDetail) {
        self.updatedAt = updatedAt
        self.values = values
    }
}

class ValuesDetailToObject: Decodable {
    var address: String?
    var customer_location: [Double]
    var customer_name: String?
    var display_data: Display_dataDetailToObject
    var gas_location1: String?
    var gas_location2: String?
    var gas_location3: String?
    var gas_location4: String?
    var kyokyusetsubi_code: String
    var location: LocationDetailToObject?
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
    
    init(address: String? = nil, customer_location: [Double], customer_name: String? = nil, display_data: Display_dataDetailToObject, gas_location1: String? = nil, gas_location2: String? = nil, gas_location3: String? = nil, gas_location4: String? = nil, kyokyusetsubi_code: String, location: LocationDetailToObject? = nil, notes: String? = nil, operators: [String]? = nil, parking_place1: String? = nil, parking_place2: String? = nil, parking_place3: String? = nil, parking_place4: String? = nil, total_cylinder_count: Int? = nil, vehicle_limit: Int? = nil, parking_location: [Double]? = nil) {
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
class LocationDetailToObject: Decodable {
    var coordinates: [Double]?
    var type: String?
    init(coordinates: [Double]? = nil, type: String? = nil) {
        self.coordinates = coordinates
        self.type = type
    }
}
class Display_dataDetailToObject: Decodable {
    var delivery_history: Dictionary<String,String>?
    var exclude_firstday: Bool?
    var origin_route_id: Int?
    
    init(delivery_history: Dictionary<String, String>? = nil, exclude_firstday: Bool? = nil, origin_route_id: Int? = nil) {
        self.delivery_history = delivery_history
        self.exclude_firstday = exclude_firstday
        self.origin_route_id = origin_route_id
    }
}

class GeolocDetailToObject: Decodable {
    var coordinates : [Double]?
    var type: String?
    init(coordinates: [Double]? = nil, type: String? = nil) {
        self.coordinates = coordinates
        self.type = type
    }
}


