//
//  Presenter_LoadTableView.swift
//  Gas
//
//  Created by Vuong The Vu on 13/02/2023.
//

import Foundation

protocol PresenterContentDelegateProtocol: AnyObject {
    func passInfoTableView()
}

class Presenter_Content_Replan {
    
    weak var passInfoTable_ContentDelegate: PresenterContentDelegateProtocol?
    
    func presenterContentReplan() {
        
    }
}
