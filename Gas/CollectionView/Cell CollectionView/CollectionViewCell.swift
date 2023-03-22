//
//  CollectionViewCell.swift
//  Gas
//
//  Created by Vuong The Vu on 20/03/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblAssetID: UILabel!
    
    @IBOutlet weak var lblEstimateTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

}
