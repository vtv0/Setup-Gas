//
//  GeneralInfoController.swift
//  Gas
//
//  Created by Vuong The Vu on 03/10/2022.
//

import UIKit

protocol ImageLabelViewDelegate: AnyObject {
    func onTap(_ sender: ImageLabelView, number: Int, type: DeliveryLocationImageType)
    func didImagePick()
}


class GeneralInfoController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var pageIndex: Int!
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
 //   @IBOutlet var ImageLabelView: UIView!
    weak var delegte: ImageLabelViewDelegate!
//    @IBOutlet weak var stackImageHorizontal: UIStackView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var stackImageGas: UIStackView!
    
    @IBAction func btnSave(_ sender: Any) {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn lưu thông tin?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let FloatingPanel = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryListController") as! DeliveryListController
            self.navigationController?.setViewControllers([FloatingPanel], animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
  //  delegate?.onTap(ImageLabelView, number: Int, type: DeliveryLocationImageType)
    override func viewDidLoad() {
        super.viewDidLoad()
        //ImageLabelView.dele = self
      //  let myDelegate = Gas.ImageLabelView()
        ImageLabelView.delegate = self
        
        //ImageLabelView.addSubview(self.view)
        //self.boolValue = true
    }
    
//    if let nav = (segue.destination as? UINavigationController)?.topViewController as? ImageLabelView {
//        ImageLabelView.delegate = self
//    }
}
extension GeneralInfoController: ImageLabelViewDelegate {
    
    func didImagePick() {
        dismiss(animated: true)
    }

    func onTap(_ sender: ImageLabelView, number: Int, type: DeliveryLocationImageType){
//        delegate?.onTap(ImageLabelView, number: number, type: DeliveryLocationImageType)
        print("xxxxxxxxxxxxxx")
        DispatchQueue.main.async {
            let imagePickerVC = sender.instantiateImagePicker(.photoLibrary)
            self.present(imagePickerVC, animated: true)
        }

    }
    
}


