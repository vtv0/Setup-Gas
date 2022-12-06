//
//  DeliveryLocationImageType.swift
//  vehicle-dispatch-speed-up-app
//
//  Created by steshima on 2021/02/08.
//

import Foundation

enum DeliveryLocationImageType: Int {
    case facilityExterior = 1
    case gasLocation
    case parking

    var text: String {
        switch self {
        case .facilityExterior:
            return "factory"
        case .gasLocation:
            return "gas"
        case .parking:
            return "location"
        }
    }
}
