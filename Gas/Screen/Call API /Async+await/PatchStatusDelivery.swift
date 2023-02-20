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
    
    func patchStatusDelivery_Async_Await(iassetID: String, status: String, dataInfoOneCustomer: Location) async throws {
        let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        
        let urlPatch: String = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)/properties"
        
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        var delivery_history_record: [String: String] =  dataInfoOneCustomer.asset?.properties?.values.display_data.delivery_history ?? [:]
        
        let time = Date()
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "yyyy-MM-dd HH:mm"
        let timeString: String = timeFormater.string(from: time)
        
        let values: [String: String] = [timeString: status]
        var delivery_history: [String: Any] = ["delivery_history": values]
        let parameter: [String: Any] = ["display_data": delivery_history_record]
        print(delivery_history_record.count)
        print(delivery_history_record)
        
        
        if delivery_history_record.count < 10 { // co < 10 ban ghi
            
            print(timeString)
            print(status)
            
            
            delivery_history_record.updateValue(status, forKey: timeString)
            print(delivery_history_record.count)
            print(delivery_history_record)
        } else {  // >= 10 ban ghi
            print(delivery_history)
            // xoa ban ghi cu nhat
            
            // them cai moi
        }
        
        
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
        
        
        
        
        
        //        let patchStatusDelivery = AF.request(urlPatch, method: .patch, parameters: parameter, encoding: JSONEncoding.default, headers: makeHeaders(token: token)).serializingDecodable(PatchDeliveryStatus.self)
        //        let patchStatusResponse = await patchStatusDelivery.response
        //        print(patchStatusResponse.response?.statusCode )
        //        switch patchStatusResponse.result {
        //
        //        case .success( let value):
        //         print(value)
        //        case .failure(let error):
        //            print("\(error)")
        //        }
    }
}
