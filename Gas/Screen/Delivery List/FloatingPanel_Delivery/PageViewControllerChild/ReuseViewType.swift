//
//  ReuseViewType.swift
//  Gas
//
//  Created by Vuong The Vu on 24/04/2023.
//

import UIKit

class ReuseViewType: UIView {
    
    @IBOutlet var mainViewType: UIView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    func loadViewFromNIB() -> UIView? {
        let nib = UINib(nibName: "ViewType", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
    func commonInit() {
        guard let viewReuseType = loadViewFromNIB() else { return }
//        viewReuseType = self.bounds
        viewReuseType.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(viewReuseType)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        //        fatalError("init(coder:) has not been implemented")
    }
    
    func loadInfoViewType() {
        //        lblInfo.text = status.title
        lblType.text = "50"
        lblNumber.text = "20"
    }
    
    
}
