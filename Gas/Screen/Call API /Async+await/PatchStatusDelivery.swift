//
//  PatchStatusDelivery.swift
//  Gas
//
//  Created by Vuong The Vu on 10/02/2023.
//

import Foundation
import Alamofire

class PatchStatusDelivery {
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    enum AFError: Error {
    
        case wrongURL
        case tokenOutOfDate
        case wrongPassword
        case remain
    }
    
    func patchStatusDelivery_Async_Await(iassetID: String, status: String) async throws {
        
        
        let urlPatch: String = "https://am-stg-iw01j.kiiapps.com/am/api/assets/\(iassetID)/properties"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let time: Date = Date()
        print(time )
        let delivery_history: [Date: String] = [time: status]
        let parameter: [String: Any] = ["display_data" : delivery_history]
//            "delivery_history": {
//                "2022-06-24 14:19": "completed"
//
//            }
//        } ]
        print(parameter)
        let patchStatusDelivery = AF.request(urlPatch, method: .patch, parameters: parameter, encoding: JSONEncoding.default, headers: makeHeaders(token: token)).serializingDecodable(GetAsset.self)
        let patchStatusResponse = await patchStatusDelivery.response
        print(patchStatusResponse.response?.statusCode )
        switch patchStatusResponse.result {
        
        case .success( let value):
         print(value)
        case .failure(let error):
            print("\(error)")
        }
    }
}
