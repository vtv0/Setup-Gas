//
//  GetVersion.swift
//  Gas
//
//  Created by Vuong The Vu on 13/02/2023.
//

import Foundation
import Alamofire

class Version: Decodable {
    var version: String
    init(version: String) {
        self.version = version
    }
}

class GetVersion {
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func getVersion() async throws -> String {
        var version: String = ""
        let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetVersion = "https://\(companyCode).kiiapps.com/am/api/version"
        let getversion = AF.request(urlGetVersion,
                                    method: .get,
                                    parameters: nil,
                                    encoding: JSONEncoding.default,
                                    headers: makeHeaders(token: token)).serializingDecodable(Version.self)
        let versionResponse = await getversion.response
        
        switch versionResponse.result {
        case .success(let value):
            print(value.version)
            version = "\(value.version)"
        case .failure(let err):
            print(err) 
        }
        return version
    }
}
