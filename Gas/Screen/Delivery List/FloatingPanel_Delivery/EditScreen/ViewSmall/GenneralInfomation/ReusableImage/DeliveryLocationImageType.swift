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
            return "Factory"
        case .gasLocation:
            return "Gas"
        case .parking:
            return "Location"
        }
    }
}
