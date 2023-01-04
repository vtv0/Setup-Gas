//
//  GetWorkerRouteLocationList.swift
//  Gas
//
//  Created by Vuong The Vu on 21/12/2022.
//

import UIKit

class GetWorkerRouteLocationList: Decodable {
    var locations: [LocationElement4]?
    var workerRoute: WorkerRoute4?

}

// MARK: - LocationElement
class LocationElement4: NSObject, Decodable {

    var arrivalTime: ArrivalTime4?
    var breakTimeSEC: Int?
    var createdAt: String?
    var latitude: Double?
    var loadCapacity, loadSupply: Int?
    var location: LocationLocation4?
    var locationID: Int?
    var locationOrder: Int
    var longitude: Double?
    var metadata: FluffyMetadata4?
    var travelTimeSECToNext, waitingTimeSEC, workTimeSEC: Int?

}

// MARK: - ArrivalTime
class ArrivalTime4: NSObject, Decodable {
    var hours, minutes, nanos, seconds: Int?
}

// MARK: - LocationLocation
class LocationLocation4: NSObject, Decodable {
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


}



// MARK: - PurpleMetadata
class PurpleMetadata4: NSObject, Codable {
    var kyokyusetsubiCode: String?
    var display_data: DisplayData4?
    var operators: [String?]?

    enum CodingKeys: String, CodingKey {
        case kyokyusetsubiCode = "KYOKYUSETSUBI_CODE"
        case display_data = "display_data"
        case operators
    }


}

// MARK: - DisplayData
class DisplayData4: NSObject, Codable {
    var delivery_history: [String: String]?
    var origin_route_id: Int?
    var excludeFirstDay: Bool? = false
    var moveToFirstDay: Bool? = false

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
class FluffyMetadata4: NSObject, Decodable {
    var customer_id, deliverType: String?
    var facility_data: [Facility_data]?
    var optionalDays: Int?
    var optionalLocation: Bool?
    var planID, planned_date, prevDate: String?

}

// MARK: - FacilityDatum
class Facility_data4: NSObject, Codable {
    var count, type: Int?

    enum Count: Int {
        case kg50 = 50
        case kg30 = 30
        case kg25 = 25
        case kg20 = 20
        case kgOther = 0
    }


}

// MARK: - WorkerRoute
class WorkerRoute4: NSObject, Codable {
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

