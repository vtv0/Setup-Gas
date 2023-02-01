//
//  RadioButon.swift
//  Gas
//
//  Created by Vuong The Vu on 01/02/2023.
//

import UIKit

class ViewRadioButon: UICollectionViewCell {

    @IBOutlet weak var btnRadio: UIButton!
    
    @IBOutlet weak var lblInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblInfo?.text = " aaaaaaaa"
    }

}
