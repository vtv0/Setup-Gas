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
    
    func getGetAsset_Block(forAsset iassetID: String, completion: @escaping ((GetAsset?) -> Void)) {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let companyCode =  UserDefaults.standard.string(forKey: "companyCode") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        AF.request(urlGetAsset, method: .get, parameters: nil, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetAsset.self) { response1 in
                
                switch response1.result {
                case .success( let value):
                    completion(value)
                    
                case .failure(_):
                    completion(nil)
                }
                
                //                if self.numberAssetIDOf7Date == self.numberCallGetAsset {
                //                    print(self.numberAssetIDOf7Date)
                //                    print(self.numberOfCallsToGetAsset)
                //                    self.hideActivity()
                //                    self.reDrawMarkers()
                //                }
            }
    }
    
}
