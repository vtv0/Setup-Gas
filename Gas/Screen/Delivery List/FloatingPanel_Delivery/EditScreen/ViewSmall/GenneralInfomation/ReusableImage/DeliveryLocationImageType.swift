//
//  DeliveryLocationImageType.swift
//  vehicle-dispatch-speed-up-app
//
//  Created by steshima on 2021/02/08.
//

import Foundation

enum DeliveryLocationImageType: Int {
    case facilityExterior = 1
    case gasLocation = 2
    case parking = 3

    var text: String {
        switch self {
        case .facilityExterior:
            return "factory1"
        case .gasLocation:
            return "gas2"
        case .parking:
            return "location3"
        }
    }
    
}
