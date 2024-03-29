//
//  TableViewCell.swift
//  Gas
//
//  Created by Vuong The Vu on 16/02/2023.
//

import UIKit
import Alamofire
import AlamofireImage




class TableViewCell: UITableViewCell, PassScreen {
    func passListImages(urls: [String], indexUrl: Int, iurlImage: String) {
        delegate?.passListImages(urls: urls, indexUrl: indexUrl, iurlImage: iurlImage)
    }
    
//    func passScreen(image: UIImage?, iurlImage: String) {
//        delegate?.passScreen(image: image, iurlImage: iurlImage)
//    }
    
  
    
    
    weak var delegate: PassScreen?
    
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
    
    var images: [UIImage]?
  
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadImage(urls: [String]) {
        var urlsNotEmpty: [String] = []
        
        self.stackViewImages.arrangedSubviews.forEach { viewImage in
            viewImage.removeFromSuperview()
            stackViewImages.removeArrangedSubview(viewImage)
        }
        
        for iurl in urls where !iurl.isEmpty {
            urlsNotEmpty.append(iurl)
            
        }
        
//        for i in 0..<urlsNotEmpty.count {
//            print(i)
//        }
        
        
        urlsNotEmpty.enumerated().forEach { ind, iurlNew in
//            print("\(iurlNew) -> \(ind)")

            let reuseImageView = ViewImage(frame: self.bounds)
            
            reuseImageView.getImage(iurl: iurlNew, indexImage: ind, urls: urlsNotEmpty)
            reuseImageView.delegatePassScreen = self
            
            stackViewImages.addArrangedSubview(reuseImageView)


        }

       
        
        
    }
    
    
    
}





