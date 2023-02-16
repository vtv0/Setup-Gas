//
//  TableViewCell.swift
//  Gas
//
//  Created by Vuong The Vu on 16/02/2023.
//

import UIKit
import Alamofire
import AlamofireImage

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var stachViewInfo: UIStackView!
    
    @IBOutlet weak var lblCustomerID: UILabel!
    @IBOutlet weak var lblDeliveryDestination: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblEstimateTime: UILabel!
    
    @IBOutlet weak var stackViewContainer: UIStackView!
   
    
    @IBOutlet weak var stackViewImages: UIStackView!
    var urls: [String] = []
    
     
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getImage(urls: [String]) {
        for iurl in urls {
            let reuseImageView = ViewImage(frame: .zero)
//            reuseView.imgImage.image =
            print(iurl)
            reuseImageView.getImage(iurl: iurl)
            stackViewImages.addArrangedSubview(reuseImageView)
        }
    }
    
}




