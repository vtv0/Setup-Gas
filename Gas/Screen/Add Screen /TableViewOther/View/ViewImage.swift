//
//  ViewImage.swift
//  Gas
//
//  Created by Vuong The Vu on 16/02/2023.
//

import UIKit
import Alamofire
import CryptoKit


protocol PassScreen: AnyObject {
    func passScreen(image: UIImage?)
    
    func passListImages(urls: [String], indexUrl: Int)
}

//class FileImage {
//    var url: String = ""
//    var imageStorage = UIImage()
//}

class ViewImage: UIView {
    
    @IBOutlet var mainViewImage: UIView!
    @IBOutlet weak var imgImage: UIImageView!
    
    weak var delegatePassScreen: PassScreen?
    var widthContraint: NSLayoutConstraint?
    
    var ratioConstraint: NSLayoutConstraint?
    
    static var listImages: [UIImage]?
    var indexImage1: Int = 0
    var urls1: [String] = []
    
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
        print("click")
        delegatePassScreen?.passScreen(image: self.imgImage.image)
        
        delegatePassScreen?.passListImages(urls: urls1, indexUrl: indexImage1)
    }
    
    func getImage(iurl: String, indexImage: Int, urls: [String]) {
        urls1 = urls
        indexImage1 = indexImage
        imgImage.loadImage(iurl: iurl) {
            var ratio: CGFloat = 0.0
            //            self.imgImage.image = UIImage(data: responseData!)
            
            // them anh vao ListImage
            //            if let imgAPI = UIImage(data: responseData!) {
            //                ViewImage.listImages?.append(imgAPI)
            //            }
            
            if let height = self.imgImage.image?.size.height,
               let width = self.imgImage.image?.size.width {
                ratio = width / height
            }
            
            // self.widthContraint?.constant = self.frame.height * CGFloat(ratio)
            
            // self.widthContraint?.constant = (self.ratio?.constant ?? 1) * self.frame.height
            self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: ratio).isActive = true
        }
        //        print(urls)
        //       print("\(iurl) - > \(indexImage)")
        //        urls1 = urls
        //        indexImage1 = indexImage
        //        // Neu da co thi lay anh trong LocalStorage
        //
        //        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        //        let url = NSURL(fileURLWithPath: path)
        //        if let pathComponent = url.appendingPathComponent(iurl.md5()+".png") {
        //            let filePath = pathComponent.path
        //            let fileManager = FileManager.default
        //            if fileManager.fileExists(atPath: filePath) {
        //                print("FILE AVAILABLE")
        //
        //                if let imgLiblary = self.getImageFromName(fileName: iurl) {
        //                    ViewImage.listImages?.append(imgLiblary)
        //                }
        //                // them anh vao ListImage
        //            } else {
        //                print("FILE NOT AVAILABLE")
        //                AF.request(iurl, method: .get).response { response in
        //                    switch response.result {
        //                    case .success(let responseData):
        //                        var ratio: CGFloat = 0.0
        //
        //
        //
        //                        self.saveImageLocally(image: UIImage(data: responseData!) ?? UIImage(), fileName: iurl)
        //
        //
        //                    case .failure(let error):
        //                        print("error--->",error)
        //                    }
        //                }
        //            }
        //        } else {
        //            print("FILE PATH NOT AVAILABLE")
        //        }
        //
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

extension UIImageView {
    func loadImage(iurl: String, completion: @escaping () -> () ) { //
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(iurl.md5()+".png") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                
                if let imgLiblary = self.getImageFromName(fileName: iurl) {
                    self.image = imgLiblary
                }
                completion()
                // them anh vao ListImage
            } else {
                print("FILE NOT AVAILABLE")
                AF.request(iurl, method: .get).response { response in
                    switch response.result {
                    case .success(let responseData):
                        
                        self.image = UIImage(data: responseData!)
                        
                        self.saveImageLocally(image: UIImage(data: responseData!) ?? UIImage(), fileName: iurl)
                        
                        
                    case .failure(let error):
                        print("error--->",error)
                    }
                    completion()
                }
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
        
    }
    
    
    func getImageFromName(fileName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent(fileName.md5()+".png")
        print(url) // HERE IS YOUR IMAGE! Do what you want with it!
        return UIImage.init(contentsOfFile: url.path)
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
    
}
