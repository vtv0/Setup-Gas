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
    
    // xet mau theo trang thai
    func statusDelivery(locationsIsCustomer: [Location]) {
        for iCustomer in locationsIsCustomer {
            
            print(iCustomer.elem?.location?.metadata?.display_data?.delivery_history)
            print(iCustomer.elem?.location?.metadata?.display_data?.delivery_history?.first)
//            if let arrStatus = iCustomer.elem?.location?.metadata?.display_data?.delivery_history {
//
//                for i in arrStatus {
//                    print(i.key)
//                    print(i.value)
//                }
//            }
        }
        
    }
    
}
