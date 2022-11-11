//
//  Marker+ExtensionViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 26/10/2022.
//

import UIKit
import MapKit

class MyPinView: MKPinAnnotationView {
    var imageView: UIImageView!
    var lblView: UILabel!
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        lblView = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named: "marker")
        lblView.textAlignment = .center
        lblView.layer.cornerRadius = lblView.frame.size.width / 2
        lblView.layer.masksToBounds = true
        self.bringSubviewToFront(lblView)
        self.addSubview(self.imageView)
        self.addSubview(self.lblView)
    }
    override var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            if let _ = imageView {
                self.imageView.image = newValue
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
