//
//  ContentReplanTableViewCell.swift
//  Gas
//
//  Created by Vuong The Vu on 07/10/2022.
//

import UIKit

class ContentReplanTableViewCell: UITableViewCell {

   
    
    @IBOutlet weak var btnCheckbox: UIButton!

    @IBAction func btnCheckBox(_ sender: UIButton) {
        
        print("click")
    }
    @IBOutlet weak var lbl_locationOrder: UILabel!

    @IBOutlet weak var lbl_kyokyusetsubi_code: UILabel!
    @IBOutlet weak var lbl_customer_name: UILabel!
    @IBOutlet weak var lbl_planned_date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
