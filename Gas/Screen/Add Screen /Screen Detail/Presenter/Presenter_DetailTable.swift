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

class detailTableView {
    weak var detailTableDelegate: DetailTableViewDelegateProtocol?
    
    
    
}
