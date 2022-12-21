//
//  GetRouteList.swift
//  Gas
//
//  Created by Vuong The Vu on 21/12/2022.
//

import Foundation

struct GetRouteList: Decodable {
    var nextPageToken: String?
    var routes: [RoutesElement]?
    
}

struct RoutesElement: Decodable {
    var areaID: Int?
    var createdAt: Date?
    //  var errorMessage:?
    var id: Int?
    var message: String?
    var operationStartTime: OperationStartTimeElement?
    var status: String?
    var tenantID: Int?
    var updatedAt: Date?
    
}

struct OperationStartTimeElement: Decodable {
    var hours: Int?
    var minutes: Int?
    var nanos: Int?
    var seconds: Int?
}
