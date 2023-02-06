//
//  RadioButon.swift
//  Gas
//
//  Created by Vuong The Vu on 01/02/2023.
//

import UIKit

class ViewRadioButton: UIView, UINavigationControllerDelegate {

    @IBOutlet var mainView: ViewRadioButton!
    @IBOutlet weak var lblInfo: UILabel!
    
    @IBOutlet weak var btnRadio: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        lblInfo?.text = " aaaaaaaa"
    }
    
    func commonInit() {
        let bundle = Bundle(for: Swift.type(of: self))
        let nib = UINib(nibName: "ViewRadioButon", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError() }
        addSubview(view)
        
        mainView.btnRadio.setImage(UIImage(named: "ic_radio_not_checked"), for: .normal)
    }

}
