//
//  GetWorkerVehicleList.swift
//  Gas
//
//  Created by Vuong The Vu on 21/12/2022.
//

import Foundation

struct WorkerVehicleList: Decodable {
    var workerVehicles: [WorkerVehicleElement]?
}

struct WorkerVehicleElement: Decodable {
    var areaID: Int?
    var cleanupWorkTimeSec: Int?
    var createdAt: Date?
    var destinationLocationID: Double?
    var id: Int?
    var initialLoadCapacity: Int?
    var maxLoadCapacity: Int?
    var metadata: Metadata?
    var originLocationID: Int?
    var preparationWorkTimeSec: Int?
    var tenantID: Int?
    var transitDelay: Int?
    var updatedAt: Date?
    var userID: Int?
    var workDelay: Int?
    var workTimeID: Int?
    
}

struct Metadata: Decodable {
    
}
