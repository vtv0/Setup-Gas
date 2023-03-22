//
//  HeaederCollectionReusableView.swift
//  Gas
//
//  Created by Vuong The Vu on 20/03/2023.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var lblName: UILabel!
    
    func config() {
        backgroundColor = .red
        lblName.text = "aaaaa"
        
    }
}
