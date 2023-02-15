//
//  Presenter_DetailTable.swift
//  Gas
//
//  Created by Vuong The Vu on 14/02/2023.
//

import Foundation

protocol DetailTableViewDelegateProtocol: AnyObject {
    func dicData()
}

class Presenter_DetailTable {
    weak var detailTableDelegate: DetailTableViewDelegateProtocol?
    
    var dicData: [Date: [Location]] = [:]
    
  
    var urlsImage = [String]()
    
    
    func getImage(locationsIsCustomer: [Location]) {  // chua duong dan Image
            print(locationsIsCustomer)
//        for iCustomer in locationsIsCustomer {
//            if let location1 = iCustomer.asset?.properties?.values.gas_location1,
//               let location2 = iCustomer.asset?.properties?.values.gas_location2,
//               
//        }
    }
    
}
