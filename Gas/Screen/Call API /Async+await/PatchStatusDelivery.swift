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
        let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        
        let urlPatch: String = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)/properties"
        print(urlPatch)
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let time: Date = Date()
        print(time )
     //   let delivery_history: [Date: String] = [time: status]
        let parameter: [String: Any] = [:]
        
//        let delivery_history: [Date: String] = [:]

//        {
//            "display_data": {
//                "delivery_history": {
//                    "2022-06-26 11:39": "waiting",
//                    "2022-08-18 10:27": "completed",
//                    "2022-08-18 13:12": "waiting",
//                    "2022-08-18 13:18": "completed",
//                    "2023-01-12 13:40": "inprogress",
//                    "2023-01-12 13:57": "waiting",
//                    "2023-01-12 14:28": "completed",
//                    "2023-01-12 14:29": "waiting",
//                    "2023-01-12 14:53": "inprogress",
//                    "2023-01-12 14:54": "failed"
//                }
//            }
//        }
        
        
        
        
        
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
