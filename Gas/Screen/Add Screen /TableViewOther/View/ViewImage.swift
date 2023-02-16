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
//        fatalError("init(coder:) has not been implemented")
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ViewImage", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func commonInit() {
        guard let viewReuse = loadViewFromNib() else { return }
        viewReuse.frame = self.bounds
        viewReuse.autoresizingMask = [.flexibleWidth, .flexibleHeight] // tu dong co dan
        self.addSubview(viewReuse)
        
        //        view.translatesAutoresizingMaskIntoConstraints = false
        
        //        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView)))
//        viewReuse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView)))
        
    }
    
    
    func getImage(iurl: String) {
        AF.request(iurl, method: .get).response { response in
            switch response.result {
            case .success(let responseData):
                self.imgImage.image = UIImage(data: responseData!, scale: 1)
            case .failure(let error):
                print("error--->",error)
            }
        }
    }
}
