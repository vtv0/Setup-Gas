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
        
        var recordNew: [String: String] = [:]
        let time = Date()
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "yyyy-MM-dd HH:mm"
        let timeString: String = timeFormater.string(from: time)
        var delivery_history_record: [String: String] =  dataInfoOneCustomer.asset?.properties?.values.display_data?.delivery_history ?? [:]
        
        if delivery_history_record.count < 10 { // co < 10 ban ghi
           
            delivery_history_record.updateValue(status, forKey: timeString)
            recordNew = delivery_history_record
            
        } else {  // >= 10 ban ghi               bi sai
            // nếu có 10 bản ghi thì xoá cái cũ nhất
            
            var dateString: [String] = []
            for irecord in delivery_history_record{
                dateString.append(irecord.key)
            }
            // convert String to Date
            var dateObjects = [Date]()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

                for date in dateString {
                    let dateObject = dateFormatter.date(from: date)
                    dateObjects.append(dateObject!)
                }

            // sort Date
            let sort = dateObjects.sorted() { $0 < $1 }
            let removeTime = sort.last
            
            
//            convert Date to String
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let removeTime = removeTime {
                let myStringDate = formatter.string(from: removeTime)
                
                // remove
                delivery_history_record.removeValue(forKey: myStringDate)
            }
        
            // thêm mới vào
            delivery_history_record.updateValue(status, forKey: timeString)
            recordNew = delivery_history_record
            print("\(recordNew) = \(recordNew.count)")
        }
        
        
        
        var delivery_history: [String: Any] = ["delivery_history": recordNew ]
        let parameter: [String: Any] = ["display_data": delivery_history]
        
        
        
        
        
        let patchStatusDelivery = AF.request(urlPatch, method: .patch, parameters: parameter, encoding: JSONEncoding.default, headers: makeHeaders(token: token)).serializingDecodable(PatchDeliveryStatus.self)
        let patchStatusResponse = await patchStatusDelivery.response
        print(patchStatusResponse.response?.statusCode )
        switch patchStatusResponse.result {

        case .success( let value):
            print(value)
        case .failure(let error):
            print("\(error)")
        }
    }
    
    
    
    
    
    
    
    // xắp sếp các bản ghi theo thứ tự tăng dần
    func deliveryHistoryASC(dicDataDeliveryHistory: [String: String]) -> [String: String] {
        
        var arrStringDate: [String] = []
        
        for idic in dicDataDeliveryHistory {
            print("\(idic.key) --> \(idic.value)")
            arrStringDate.append(idic.key)
        }
        var arrKeyDate = [Date]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        // chuyen string to date
        arrStringDate.forEach({ stringDate in
            if let dateKey = dateFormatter.date(from: stringDate) {
                arrKeyDate.append(dateKey)
            }
        })
        
        print(arrKeyDate)
        
        var deliveryRecordASC: [String: String] = [:]
        //        arrStringDate.sorted( { h1, h2 in
        //
        //
        //        })
        //
        //        arr.sort { h1, h2 in
        //            let df = DateFormatter()
        //            df.dateFormat = "yyyy-MM-dd HH:mm"
        //            if let d1 = df.date(from: h1.date), let d2 = df.date(from: h2.date) {
        //                return d1 < d2
        //            }
        //            return true
        //        }
        //        for idic in dicDataDeliveryHistory {
        //            if let status = arr.last?.status {
        //                return DeliveryHistory1.init(rawValue: status) ?? .waiting
        //            }
        //        }
        
        
        
        
        return dicDataDeliveryHistory
    }
}
