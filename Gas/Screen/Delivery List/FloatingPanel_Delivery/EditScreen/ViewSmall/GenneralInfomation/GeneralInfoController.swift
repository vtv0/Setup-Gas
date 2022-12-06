//
//  GeneralInfoController.swift
//  Gas
//
//  Created by Vuong The Vu on 03/10/2022.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit
import FloatingPanel
import Contacts

class GeneralInfoController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var pageIndex: Int!
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
    var elem: [LocationElement] = []
    var asset = GetAsset(assetModelID: 0, enabled: true)
    
    @IBOutlet weak var viewGasLocation1: ImageLabelView!
    @IBOutlet weak var viewGasLocation2: ImageLabelView!
    @IBOutlet weak var viewGasLocation3: ImageLabelView!
    @IBOutlet weak var viewGasLocation4: ImageLabelView!
    
    @IBOutlet weak var viewParkingLocation5: ImageLabelView!
    @IBOutlet weak var viewParkingLocation6: ImageLabelView!
    @IBOutlet weak var viewParkingLocation7: ImageLabelView!
    @IBOutlet weak var viewParkingLocation8: ImageLabelView!
    
    @IBOutlet weak var viewNotes: UIView!
    @IBOutlet weak var txtFieldNotes: UITextView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate
        ImageLabelView.delegatePassSelectedImage = self
       

        if let url1 = UserDefaults.standard.string(forKey: "GasLocation1") {
           
            viewGasLocation1.mainImageView.loadFrom(URLAddress: url1)
        }
        
        if let url2 = UserDefaults.standard.string(forKey: "GasLocation2") {
           
            viewGasLocation2.mainImageView.loadFrom(URLAddress: url2)
        }
        
        if let url3 = UserDefaults.standard.string(forKey: "GasLocation3") {
          
            viewGasLocation3.mainImageView.loadFrom(URLAddress: url3)
        }
        
        if let url4 = UserDefaults.standard.string(forKey: "GasLocation4") {
           
            viewGasLocation4.mainImageView.loadFrom(URLAddress: url4)
        }
        
        if let url5 = UserDefaults.standard.string(forKey: "ParkingPlace5") {
         
            viewParkingLocation5.mainImageView.loadFrom(URLAddress: url5)
        }

        if let url6 = UserDefaults.standard.string(forKey: "ParkingPlace6") {
           
            viewParkingLocation6.mainImageView.loadFrom(URLAddress: url6)
        }

        if let url7 = UserDefaults.standard.string(forKey: "ParkingPlace7") {
           
            viewParkingLocation7.mainImageView.loadFrom(URLAddress: url7)
        }

        if let url8 = UserDefaults.standard.string(forKey: "ParkingPlace8") {
           
            viewParkingLocation8.mainImageView.loadFrom(URLAddress: url8)
        }
        
        if let notes = UserDefaults.standard.string(forKey: "Notes") {
            txtFieldNotes.text = notes
        }
    }
    
}


extension GeneralInfoController: ImageLabelViewDelegate {
    
    func didImagePick() {
        dismiss(animated: true)
    }
    
    func onTap(_ sender: ImageLabelView, number: Int, type: DeliveryLocationImageType) {
        
        print("anh so: \(number)")
        DispatchQueue.main.async {
            let imagePickerVC = sender.instantiateImagePicker(.photoLibrary)
            self.present(imagePickerVC, animated: true)
        }
    }
}

extension GeneralInfoController: PassImageDelegateProtocol {
    func passNotes(notes: String) {
        UserDefaults.standard.removeObject(forKey: "Notes")
        UserDefaults.standard.set(notes, forKey: "Notes")
    }
    
    func passUrlGasLocation1(urlImage1: String) {
        UserDefaults.standard.removeObject(forKey: "GasLocation1")
        UserDefaults.standard.set(urlImage1, forKey: "GasLocation1")
    }
    
    func passUrlGasLocation2(urlImage2: String) {
        UserDefaults.standard.removeObject(forKey: "GasLocation2")
        UserDefaults.standard.set(urlImage2, forKey: "GasLocation2")

    }
    
    func passUrlGasLocation3(urlImage3: String) {
        UserDefaults.standard.removeObject(forKey: "GasLocation3")
        UserDefaults.standard.set(urlImage3, forKey: "GasLocation3")
    }
    
    func passUrlGasLocation4(urlImage4: String) {
        UserDefaults.standard.removeObject(forKey: "GasLocation4")
        UserDefaults.standard.set(urlImage4, forKey: "GasLocation4")
    }
    
    func passUrlParkingPlace5(urlImage5: String) {
        UserDefaults.standard.removeObject(forKey: "ParkingPlace5")
        UserDefaults.standard.set(urlImage5, forKey: "ParkingPlace5")
    }
    
    func passUrlParkingPlace6(urlImage6: String) {
        UserDefaults.standard.removeObject(forKey: "ParkingPlace6")
        UserDefaults.standard.set(urlImage6, forKey: "ParkingPlace6")
    }
    
    func passUrlParkingPlace7(urlImage7: String) {
        UserDefaults.standard.removeObject(forKey: "ParkingPlace7")
        UserDefaults.standard.set(urlImage7, forKey: "ParkingPlace7")
    }
    
    func passUrlParkingPlace8(urlImage8: String) {
        UserDefaults.standard.removeObject(forKey: "ParkingPlace8")
        UserDefaults.standard.set(urlImage8, forKey: "ParkingPlace8")
    }
    
}


