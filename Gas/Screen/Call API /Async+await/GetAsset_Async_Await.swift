//
//  File.swift
//  Gas
//
//  Created by Vuong The Vu on 09/01/2023.
//

import UIKit
import Alamofire
 
var companyCode = UserDefaults.standard.string(forKey: "companyCode")
 
class GetAsset_Async_Await {
    let url: String?
    
    init(url: String?) {
        self.url = url
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func getGetAsset_Async_Await(forAsset iassetID: String) async -> GetAsset {
        var getAsset = GetAsset()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        AF.request(urlGetAsset, method: .get, parameters: nil, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetAsset.self) { response1 in
                
//                self.numberOfCallsToGetAsset += 1
                switch response1.result {
                case .success( let value):
                    print(value)
//                    completion(value)
                    
                    
                case .failure(let error):
                    print("\(error)")
//                    completion(nil)
                }
                
//                if self.numberAssetIDOf7Date == self.numberOfCallsToGetAsset {
//                    print(self.numberAssetIDOf7Date)
//                    print(self.numberOfCallsToGetAsset)
//                    self.hideActivity()
//                    self.reDrawMarkers()
//                }
            }
        return getAsset
    }
    func loadAPIGetAsset(){}
    
    
}
