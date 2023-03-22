//
//  Delivery_history.swift
//  Gas
//
//  Created by Vuong The Vu on 08/03/2023.
//

import UIKit
import FMDB
import SQLite3
import SQLite

class DeliveryHistory_Elem: NSObject {
    var KYOKYUSETSUBI_CODE = "KYOKYUSETSUBI_CODE"
    var date = "date"
    var status = "status"
    
    override init() {
        super.init()
    }
}
