//
//  ViewImage.swift
//  Gas
//
//  Created by Vuong The Vu on 16/02/2023.
//

import UIKit
import Alamofire

class ViewImage: UIView {
    
    @IBOutlet var mainViewImage: UIView!
    @IBOutlet weak var imgImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ViewImage", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func commonInit() {
        guard let viewReuse = loadViewFromNib() else { return }
        viewReuse.frame = self.bounds
        viewReuse.autoresizingMask = [.flexibleWidth, .flexibleHeight]  // tu dong co dan
        self.addSubview(viewReuse)
        
    }
    
    
    func getImage(iurl: String) {
        AF.request(iurl, method: .get).response { response in
            switch response.result {
            case .success(let responseData):
                self.imgImage.image = UIImage(data: responseData!, scale: 1.0)
                
             let height = self.imgImage.image?.size.height ?? 0
               let width = self.imgImage.image?.size.width ?? 0
                
                let ratio = (height / width)
                
                if ratio > 1 {
                    print(ratio )
                    self.mainViewImage.frame = CGRect(x: 0,
                                                 y: 0,
                                                 width: (self.mainViewImage.frame.height / ratio),
                                                 height: self.mainViewImage.frame.height)
                } else if ratio < 1 {
                    print("Ratio < 1: \(ratio)")
                    self.imgImage.frame = CGRect(x: 0,
                                                 y: 0,
                                                 width: (self.imgImage.frame.height / ratio),
                                                 height: self.mainViewImage.frame.height)
                }
                // co 2 truong hop  ti le width/height > 1
                
                
//                self.imgImage.scalesLargeContentImage = (2 != 0)
                
//                let targetSize = CGSize(width: 100, height: 100)
//                let scaledImage = self.imgImage.image?.scalePreservingAspectRatio(
//                    targetSize: targetSize
//                )
            case .failure(let error):
                print("error--->",error)
            }
        }
    }
    
}
