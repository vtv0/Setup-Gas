//
//  ViewImage.swift
//  Gas
//
//  Created by Vuong The Vu on 16/02/2023.
//

import UIKit

class ViewImage: UIView {

    @IBOutlet weak var imgImage: UIImageView!
    
    
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
}
