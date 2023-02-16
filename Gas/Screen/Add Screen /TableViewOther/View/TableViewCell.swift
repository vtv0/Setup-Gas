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
    
    @IBOutlet weak var stackViewImages: UIStackView!
    
    var urls: [String] = [] {
        didSet {
           
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for iurl in urls {
            let reuseView = ViewImage(frame: .zero)
            reuseView.imgImage.image = 
            
            
            stackViewImages.addArrangedSubview(reuseView)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getImage(iurl: String) {
        AF.request(iurl, method: .get).response { response in
            switch response.result {
            case .success(let responseData):
                responseData.
                cellImage.imgImage.image = UIImage(data: responseData!, scale: 1)
            case .failure(let error):
                print("error--->",error)
            }
        }
    }
}




