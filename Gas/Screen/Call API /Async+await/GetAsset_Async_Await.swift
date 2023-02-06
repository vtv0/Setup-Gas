//
//  File.swift
//  Gas
//
//  Created by Vuong The Vu on 09/01/2023.
//

import UIKit
import Alamofire


class GetAsset_Async_Await {
    
    let url: String? = nil
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func getGetAsset_Async_Await(forAsset iassetID: String) async throws -> GetAsset {
        var getAsset = GetAsset()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        let getAsset1 = AF.request(urlGetAsset, method: .get, parameters: nil, headers: self.makeHeaders(token: token)).serializingDecodable(GetAsset.self)
        let getAssetResponse = await getAsset1.response
        
        switch getAssetResponse.result {
        case .success( let value):
            getAsset = value
        case .failure(let error):
            print("\(error)")
        }
        return getAsset
    }
    
}
