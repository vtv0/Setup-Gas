//
//  ViewImage.swift
//  Gas
//
//  Created by Vuong The Vu on 16/02/2023.
//

import UIKit
import Alamofire
import CryptoKit

class FileImage {
    var url: String = ""
    var imageStorage = UIImage()
}

class ViewImage: UIView {
    
    @IBOutlet var mainViewImage: UIView!
    @IBOutlet weak var imgImage: UIImageView!
    
    var widthContraint: NSLayoutConstraint?
    
    var ratioConstraint: NSLayoutConstraint?
    
    
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
        viewReuse.autoresizingMask = [.flexibleWidth, .flexibleHeight]  // tu dong co dan
        self.addSubview(viewReuse)
        self.backgroundColor = .blue
//        widthContraint = self.widthAnchor.constraint(equalToConstant: 0)
//        widthContraint?.isActive = true
        
//        ratioConstraint = self.aspectRatio(0)
//        ratioConstraint?.isActive = true
        
        viewReuse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickImage)))
    }
    
    @objc func clickImage() {
        print("clickkkkk")
        self.inputViewController?.presentationController(FullScreenImageVC())
    }
    
    func getImage(iurl: String) {
        
        // Neu da co thi lay anh trong LocalStorage
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(iurl.md5()+".png") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                self.getImageFromName(fileName: iurl)
            } else {
                print("FILE NOT AVAILABLE")
                AF.request(iurl, method: .get).response { response in
                    switch response.result {
                    case .success(let responseData):
                        var ratio: CGFloat = 0.0
                        self.imgImage.image = UIImage(data: responseData!)
                        
                        if let height = self.imgImage.image?.size.height,
                           
                            let width = self.imgImage.image?.size.width {
                            ratio = width / height
                        }
//                        self.widthContraint?.constant = self.frame.height * CGFloat(ratio)
                        
//                        self.widthContraint?.constant = (self.ratio?.constant ?? 1) * self.frame.height
                        self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: ratio).isActive = true
                        
                        self.saveImageLocally(image: UIImage(data: responseData!) ?? UIImage(), fileName: iurl)
                        
                        
                    case .failure(let error):
                        print("error--->",error)
                    }
                }
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
    }
    
    func saveImageLocally(image: UIImage, fileName: String) {
        
        // Obtaining the Location of the Documents Directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Creating a URL to the name of your file
        let url = documentsDirectory.appendingPathComponent(fileName.md5()+".png")
        if let data = image.pngData() {
            do {
                try data.write(to: url) // Writing an Image in the Documents Directory
            } catch {
                print("Unable to Write \(fileName) Image Data to Disk")
            }
        }
    }
    
    
    
    func getImageFromName(fileName: String) {
        var ratio1: CGFloat = 0.0
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent(fileName.md5()+".png")
        print(url)
        self.imgImage.image = UIImage.init(contentsOfFile: url.path)  // HERE IS YOUR IMAGE! Do what you want with it!
        
        
        if let height = self.imgImage.image?.size.height,
            let width = self.imgImage.image?.size.width {
            ratio1 = (width / height)
            self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: ratio1).isActive = true
        }
        
//        if let widthContraintDidRemove = widthContraint {  // xoa trong truong hop khoi tao nhieu lan width
//            self.removeConstraint(widthContraintDidRemove)
//        }
        
    }
    
    
//    override func layoutSubviews() {
//        var ratio2: Float = 0.0
//        if let height = self.imgImage.image?.size.height,
//           let width = self.imgImage.image?.size.width {
//            ratio2 = Float((width / height))
//
////            widthContraint?.constant = self.frame.height * CGFloat(ratio2)
//
//
//            self.ratioConstraint?.constant = CGFloat(ratio2)
//
//        }
//    }
    
}

extension String {
    func md5() -> String {
        return Insecure.MD5.hash(data: self.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }
}


extension UIView {
    func aspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: ratio, constant: 0)
    }
}
