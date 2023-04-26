//
//  ReuseViewType.swift
//  Gas
//
//  Created by Vuong The Vu on 24/04/2023.
//

import UIKit




class ReuseViewType: UIView {
   
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var viewContainLBL: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func loadViewFromNIB() -> UIView? {
        let nib = UINib(nibName: "ViewType", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func commonInit() {
        guard let viewReuseType = loadViewFromNIB() else { return }
        viewReuseType.frame = self.bounds
        viewReuseType.autoresizingMask = [.flexibleWidth, .flexibleHeight]
     
        self.addSubview(viewReuseType)
    }
    
    
    func loadInfoViewType(iFacilityDataDetail: Facility_data) {
            //        lblInfo.text = status.title
        lblType.text = "\(iFacilityDataDetail.type ?? 0)kg"
        lblNumber.text = "\(iFacilityDataDetail.count ?? 0)"
        }
    
}
