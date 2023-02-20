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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackViewImages: UIStackView!

    var urls: [String] = []
    var listUrls: [[String]] = []
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadImage(urls: [String]) {
        self.stackViewImages.arrangedSubviews.forEach { viewImage in
            viewImage.removeFromSuperview()
        }
        
//        for iurl in urls where !iurl.isEmpty {
//            let reuseImageView = ViewImage(frame: self.bounds)
////            reuseImageView.getImage(iurl: iurl)
////            reuseImageView.frame = CGRect(x: 0, y: 0, width: 80, height: self.stackViewImages.frame.height)
////            reuseImageView.imgImage.frame = CGRect(x: 0, y: 0, width: 80, height: self.stackViewImages.frame.height)
////            stackViewImages.bounds = CGRect(x: 0, y: 0, width: 80, height: self.stackViewImages.frame.height)
//             
//            stackViewImages.addArrangedSubview(reuseImageView)
//        }
        
    }
    
}




