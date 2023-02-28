//
//  FullScreenImageVC.swift
//  Gas
//
//  Created by Vuong The Vu on 27/02/2023.
//

import UIKit
import CoreGraphics
import CoreImage
import ImageIO

class FullScreenImageVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollViewImage: UIScrollView!
    @IBOutlet weak var imgFullscreenImage: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgFullscreenImage.image = image
        scrollViewImage.delegate = self
        
        scrollViewImage.maximumZoomScale = 2.0
        
//        scrollViewImage.minimumZoomScale = 0.5
//                scrollViewImage.zoomScale = 1.0
        
//        scrollViewImage.contentMode = .aspectFill
        
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        imgFullscreenImage?.isUserInteractionEnabled = true
        doubleTap.numberOfTapsRequired = 2
        imgFullscreenImage?.addGestureRecognizer(doubleTap)
        
        
    }
    
    
    @objc func tapDetected() {
        let location = CGPoint(x: scrollViewImage.center.x, y: scrollViewImage.center.y)
        
        if scrollViewImage.zoomScale <= 1 {
            let sizeRect = zoomRectForScale(scale: scrollViewImage.maximumZoomScale, center: location)
            scrollViewImage.zoom(to: sizeRect, animated: true)
            
        } else if scrollViewImage.zoomScale > 1 {
            scrollViewImage.zoom(to: zoomRectForScale(scale: 1.0, center: location), animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgFullscreenImage
    }
    
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        if let imageV = self.imgFullscreenImage {
            zoomRect.size.height = imageV.frame.size.height / scale
            zoomRect.size.width  = imageV.frame.size.width  / scale
            let newCenter = imageV.convert(center, from: self.scrollViewImage)
            zoomRect.origin.x = newCenter.x - ((zoomRect.size.width / 2 ))
            zoomRect.origin.y = newCenter.y - ((zoomRect.size.height / 2 ))
        }
        return zoomRect;
    }
}

extension CGPoint {
    func scaledBy(scale: CGFloat) -> CGPoint {
        return CGPoint(x: x * scale, y: y * scale)
    }
}
