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
        
        for iurl in urls where !iurl.isEmpty {
            let reuseImageView = ViewImage(frame: self.bounds)
            stackViewContainer.setCustomSpacing( 10, after: reuseImageView.imgImage) // khoảng cách các khung màu xanh dương -> S max
            
            reuseImageView.backgroundColor = .blue
            // Mục đích: làm cho chiều rộng màu xanh dương nhỏ lại
//            reuseImageView.frame = CGRect(x: 0, y: 0, width: self.stackViewImages.frame.width / 4, height: self.stackViewImages.frame.height)
            
            
            reuseImageView.getImage(iurl: iurl)
            reuseImageView.mainViewImage.backgroundColor = .red
            reuseImageView.mainViewImage.frame = CGRect(x: 10, y: 0, width: 65, height: self.stackViewImages.frame.height)  // kích thước khung màu đỏ
            stackViewImages.addArrangedSubview(reuseImageView)
            
            
        }
        
    }
    
}




