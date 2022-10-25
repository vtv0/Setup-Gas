//
//  ImageLabelView.swift
//  vehicle-dispatch-speed-up-app
//
//  Created by kwakata on 2021/02/09.
//

import UIKit
class ImageLabelView: UIView, UINavigationControllerDelegate {
    
    static var delegate: ImageLabelViewDelegate?
    private var deliveryLocationType: DeliveryLocationImageType = .facilityExterior
    private var isSetImage: Bool = false
    private(set) var newFileName: String?
    public private(set) var isChanged: Bool = false
    
    @IBInspectable var image: UIImage? {
        didSet {
            if let image = image {
                mainImageView.contentMode = .scaleAspectFill
                mainImageView.image = image
                isSetImage = true
            } else {
                mainImageView.contentMode = .center
                mainImageView.image = UIImage(named: "camera")
                isSetImage = false
            }
        }
    }
    
    @IBInspectable var label: String = "" {
        didSet {
            labelView.text = label
        }
    }
    
    @IBInspectable var number: Int = 1 {
        didSet {
            numberView.text = String(number)
        }
    }
    @IBInspectable var locationType: Int {
        get {
            return deliveryLocationType.rawValue
        }
        set(newValue) {
            deliveryLocationType = DeliveryLocationImageType(rawValue: newValue) ?? .facilityExterior
            switch deliveryLocationType {
            case .facilityExterior:
                iconImageView.image = UIImage(named: "factory")
            case .gasLocation:
                iconImageView.image = UIImage(named: "gas")
            case .parking:
                iconImageView.image = UIImage(named: "P")
            }
        }
    }
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var labelView: UILabel!
    @IBOutlet private weak var numberView: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setImageURL(url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global().async {
            do {
                let imageData: Data? = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let data = imageData {
                        self.image = UIImage(data: data)
                    } else {
                        self.image = nil
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
    }
    
    func changeImage(image: UIImage?, fileName: String) {
        self.image = image
        newFileName = fileName
        isChanged = true
    }
    
    func removeImage() {
        image = nil
        if newFileName != nil { newFileName = nil }
        isChanged = true
    }
    
    func hasImage() -> Bool {
        return isSetImage
    }
    
    func instantiateImagePicker(_ sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.modalPresentationStyle = .fullScreen
        return imagePicker
    }
    
    private func commonInit() {
        let bundle = Bundle(for: Swift.type(of: self))
        let nib = UINib(nibName: "ImageLabelView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError()
        }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[view]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: bindings
            )
        )
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[view]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: bindings
            )
        )
        
        mainImageView.layer.cornerRadius = mainImageView.frame.size.width * 0.1
        mainImageView.clipsToBounds = true
        numberView.layer.cornerRadius = mainImageView.frame.size.width * 0.1
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView)))
    }
    @objc private func onTapView() {
        
        ImageLabelView.delegate?.onTap(self, number: number, type: deliveryLocationType)
    }
}

extension ImageLabelView: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else {
            ImageLabelView.delegate?.didImagePick()
            return
        }
        var fileName = ""
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL,
           let imageFileName = imageURL.lastPathComponent
        {
            var arr = imageFileName.split(separator: ".")
            arr.removeLast()
            fileName = arr.joined()
        } else {
            
            fileName = "ffffff"
        }
        let newImage = resizeImage(image)
        changeImage(image: newImage, fileName: fileName)
        ImageLabelView.delegate?.didImagePick()
    }
    func resizeImage(_ image: UIImage) -> UIImage {
        let compressionQuality = 0.9
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(70), height: CGFloat(84))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
}