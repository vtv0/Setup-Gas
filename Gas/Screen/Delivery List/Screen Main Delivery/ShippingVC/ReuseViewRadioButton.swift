//
//  ReuseViewRadioButton.swift
//  Gas
//
//  Created by Vuong The Vu on 06/02/2023.
//

import UIKit

protocol PassStatusDelivery: AnyObject {
    func onTap(_ sender: ReuseViewRadioButton, status: StatusDelivery)
}

class ReuseViewRadioButton: UIView {
    weak var delegateStatus: PassStatusDelivery?
    var status: StatusDelivery!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    
    @IBOutlet weak var btnRadioButton: UIButton! {
        didSet {
            btnRadioButton.isEnabled = false
            btnRadioButton.setImage(UIImage(named: "ic_radio_not_checked"), for: .normal)
        }
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
    
    func loadInfo() {
        lblInfo.text = status.title
    }
    
    func commonInit() {
        guard let viewReuse = loadViewFromNib() else { return }
        viewReuse.frame = self.bounds
        viewReuse.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(viewReuse)
        
        //        view.translatesAutoresizingMaskIntoConstraints = false
        
        //        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView)))
        viewReuse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView)))
        
    }
    
    @objc func onTapView() {
        delegateStatus?.onTap(self, status: status)
    }
    
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ViewRadioButton", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
