//
//  ViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 26/09/2022.
//

import UIKit

class ViewController: UIViewController {
    func updateAnswer(_ answer: String) {
        
    }
    
    static var viewActivity: ActivityIndicator!
    
    
    
   // @IBOutlet weak var activityIndicator: ActivityIndicator!
    
    
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    var bRec:Bool = true
    @IBOutlet weak var btnSaveAccount: UIButton!
    @IBAction func btnSaveAccount(_ sender: Any) {
        bRec = !bRec
        if (bRec ){
            self.btnSaveAccount.setImage(UIImage(named: "checkmarkEmpty"), for: .normal)
        } else {
            self.btnSaveAccount.setImage(UIImage(named: "checkmark"), for: .normal)
        }
        
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        print("click đang nhap")
        
       // activityIndicator.isHidden = false
        let mhDeliveryList = storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
        self.showActivity()

//        let delay = 1 // seconds
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) { [self] in
//            
//            self.hiddenActivity()
//  
//            self.navigationController?.pushViewController(mhDeliveryList, animated: true)
//        }
        let delay1 = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay1)) { [self] in
            
            self.hiddenActivity()
  
            self.navigationController?.pushViewController(mhDeliveryList, animated: true)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgIcon.image = UIImage(named:"icon.jpg")
//        ActivityIndicator.delegate = self
      //  activityIndicator.isHidden = true
        
        //self.navigationController?.navigationBar.backgroundColor = .white
    }
    
}
