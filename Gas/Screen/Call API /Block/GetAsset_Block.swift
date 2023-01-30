//
//  GetAsset.swift
//  Gas
//
//  Created by Vuong The Vu on 12/01/2023.
//

import UIKit
import Alamofire

class GetAsset_Block {
    let url: String? = nil
    //  var numberCallGetAsset: Int = 0
    //
    //    init(url: String?) {
    //        self.url = url
    //    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func getGetAsset_Block(forAsset iassetID: String, completion: @escaping ((GetAsset?, (CaseError?)) -> Void)) {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let companyCode =  UserDefaults.standard.string(forKey: "companyCode") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        AF.request(urlGetAsset, method: .get, parameters: nil, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetAsset.self) { response1 in
                
                switch response1.result {
                case .success( let value):
                    completion(value, GetAsset_Block.CaseError.ok)
                    
                case .failure(_):
                    if response1.response?.statusCode == 401 {
                        completion(nil, CaseError.tokenOutOfDate)
                    } else {
                        completion(nil, CaseError.remain)
                    }
                }
            }
    }
    enum CaseError: String {
        case ok
        case tokenOutOfDate

        case remain
    }
}
