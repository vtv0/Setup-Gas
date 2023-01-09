//
//  RadioTableViewCell.swift
//  Gas
//
//  Created by Vuong The Vu on 09/01/2023.
//

import UIKit

class RadioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnRadioButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnRadioButton.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
