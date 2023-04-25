//
//  ViewImage.swift
//  Gas
//
//  Created by Vuong The Vu on 16/02/2023.
//

import UIKit
import Alamofire

protocol PassScreen: AnyObject {
    //    func passScreen(image: UIImage?, iurlImage: String)
    func passListImages(urls: [String], indexUrl: Int, iurlImage: String)
}

class ViewImage: UIView {
    
    @IBOutlet var mainViewImage: UIView!
    @IBOutlet weak var imgImage: UIImageView!
    
    weak var delegatePassScreen: PassScreen?
    var widthContraint: NSLayoutConstraint?
    
    var ratioConstraint: NSLayoutConstraint?
    
    static var listImages: [UIImage]?
    var indexImage1: Int = 0
    var urls1: [String] = []
    var iurlImage: String = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ViewImage", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func commonInit() {
        guard let viewReuse = loadViewFromNib() else { return }
        viewReuse.frame = self.bounds
        viewReuse.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(viewReuse)
        self.backgroundColor = .blue
        viewReuse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickImage)))
    }
    
    @objc func clickImage() {
        delegatePassScreen?.passListImages(urls: urls1, indexUrl: indexImage1, iurlImage: iurlImage)
    }
    
    
    func getImage(iurl: String, indexImage: Int, urls: [String]) {
        iurlImage = iurl
        urls1 = urls
        indexImage1 = indexImage
        imgImage.loadImageDBorAPI(iurl: iurl) {
            var ratio: CGFloat = 0.0
            if let height = self.imgImage.image?.size.height,
               let width = self.imgImage.image?.size.width {
                ratio = width / height
            }
            self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: ratio).isActive = true
        }
    }
    
    
    func saveImageLocally(image: UIImage, fileName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent(fileName.md5()+".png")
        if let data = image.pngData() {
            do {
                try data.write(to: url)
            } catch {
                print("Unable to Write \(fileName) Image Data to Disk")
            }
        }
    }
}

extension UIView {
    func aspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: ratio, constant: 0)
    }
}

extension UIImageView {
    func loadImageDBorAPI(iurl: String, completion: (() -> Void)? = nil ) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(iurl.md5()+".png") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                if let imgLiblary = self.getImageFromName(fileName: iurl) {
                    self.image = imgLiblary
                }
                
                completion?()
                
            } else {
                AF.request(iurl, method: .get).response { response in
                    switch response.result {
                    case .success(let responseData):
                        self.image = UIImage(data: responseData!)
                        self.saveImageLocally(image: UIImage(data: responseData!) ?? UIImage(), fileName: iurl)
                        
                    case .failure(let error):
                        print("error--->",error)
                    }
                    completion?()
                }
            }
            
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
    }
    
    func getImageFromName(fileName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent(fileName.md5()+".png")
        return UIImage.init(contentsOfFile: url.path)
    }
    
    func saveImageLocally(image: UIImage, fileName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent(fileName.md5()+".png")
        if let data = image.pngData() {
            do {
                try data.write(to: url) // Writing an Image in the Documents Directory
            } catch {
                print("Unable to Write \(fileName) Image Data to Disk")
            }
        }
    }
    
}
