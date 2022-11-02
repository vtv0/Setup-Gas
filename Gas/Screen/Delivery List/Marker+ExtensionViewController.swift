//
//  Marker+ExtensionViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 26/10/2022.
//

import UIKit
import MapKit

class MyPinView: MKPinAnnotationView {
    private var imageView: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.imageView.image = UIImage(named: "marker")
        self.addSubview(self.imageView)
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
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
