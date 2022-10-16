//
//  ActivityIndicator.swift
//  Gas
//
//  Created by vu the vuong on 13/10/2022.
//


protocol ActivityDelgate: AnyObject {
    //func showLoading(indentifier: String)
    func updateAnswer(_ answer: String)
    
    // func hideLoading()
}
import UIKit

class ActivityIndicator: UIView {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static var delegate: ActivityDelgate!
    
    
    let nibName = "ActivityIndicator"
    
    //        required init?(coder aDecoder: NSCoder) {
    //            super.init(coder: aDecoder)
    //            commonInit()
    //        }
    
    //        override init(frame: CGRect) {
    //            super.init(frame: frame)
    //            commonInit()
    //        }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    var targetView: UIView?
    
    var view: UIView!
    required init(forView view: UIView) {
        super.init(frame: view.bounds)
        targetView = view
        self._setup()
        targetView?.addSubview(self)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._setup()
    }
    
    private func _setup() {
        view = _loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    private func _loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
    func showLoading(withCompletion completion: (() -> Swift.Void)? = nil) {
        UIView.animate(withDuration:1.0, animations: {
        }) { _ in
            completion?()
        }
    }
    
    func hideLoading() {
        UIView.animate(withDuration: 0.5, animations: {
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
}
