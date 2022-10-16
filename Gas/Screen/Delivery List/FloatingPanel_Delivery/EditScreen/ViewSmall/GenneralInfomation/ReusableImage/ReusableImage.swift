//
//  ReusableImage.swift
//  Gas
//
//  Created by Vuong The Vu on 13/10/2022.
//

import UIKit


protocol ReusableImageDelegate: AnyObject {
    func onTap(_ sender: ReusableImage, number: Int, type: GeneralInfoController)
    
}
class ReusableImage: UIView {
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    
    let nibName = "ReusableImage"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: Swift.type(of: self))
        let nib = UINib(nibName: "ReusableImage", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError()
        }
        //addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        //imgImage.layer.cornerRadius = imgImage.frame.size.width * 0.1
        // imgImage.clipsToBounds = true
        
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView)))
    }
    
    @objc private func onTapView() {
        // delegate?.onTap(self, number: number, type: GeneralInfoController)
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

extension ReusableImage : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,   info: [UIImagePickerController.InfoKey: Any]) {
        guard info[.imageURL] is URL else {
            return
        }
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImage = pickedImage
            imgImage.image = selectedImage
        }
     //   dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     //   dismiss(animated: true, completion: nil)
    }
    
    func selectImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = .fullScreen
           // present(imagePicker, animated: true, completion: nil)
        }
    }
}
