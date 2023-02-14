//
//  DetailTableViewCell.swift
//  Gas
//
//  Created by Vuong The Vu on 14/02/2023.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCustomerCode: UILabel!
    
    @IBOutlet weak var lblReceivingAddress: UILabel!
    
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    
    @IBOutlet weak var lblEstimateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
