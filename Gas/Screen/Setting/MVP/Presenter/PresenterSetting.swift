//
//  PrisenterSeting.swift
//  Gas
//
//  Created by Vuong The Vu on 13/02/2023.
//

import Foundation


protocol SettingDelegateProtocol: AnyObject {
    func passVersion(version: String)
}

class PresenterSetting {
    
    weak var delegateSetting: SettingDelegateProtocol?
    
    func getVersion() async {
        do {
           let version = try await GetVersion().getVersion()
            DispatchQueue.main.async {
                self.delegateSetting?.passVersion(version: version)
            }
            
        } catch {
            //
        }
       
    }
    
}
