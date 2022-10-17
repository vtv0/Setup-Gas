//
//  ViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 26/09/2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate{
    
    var viewActivity: ActivityIndicator!
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtId: UITextField!
    
    
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
        let mhDeliveryList = storyboard?.instantiateViewController(identifier:  "DeliveryListController") as! DeliveryListController
        self.showActivity()
        let delay1 = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay1)) { [self] in
            self.hideActivity()
            self.navigationController?.pushViewController(mhDeliveryList, animated: true)
        }
        
        
        
    }
    
    var token = UserDefaults.standard.string(forKey: "response") ?? ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgIcon.image = UIImage(named:"icon.jpg")
        
        let expiredDate = Calendar.current.date(byAdding: .hour, value: 12, to: Date())!
        
        let parameters: [String: Any] = ["username": "dev_driver1@dev1.test" , "password" : "dev123456" , "expiresAt": Int64(expiredDate.timeIntervalSince1970 * 1000) , "grant_type": "password" ]
        //        AF.request("https://am-stg-iw01j.kiiapps.com/am/api/oauth2/token",method: .post, parameters: parameters).response  { response in
        //            debugPrint(response)
        // print(JSON)
        // print(error)
        //        }
        
        func makeHeaders() -> HTTPHeaders {
            var headers: [String: String] = [:]
            headers["Content-Type"] = "application/json"
            return HTTPHeaders(headers)
        }
        
        //        AF.request("https://am-stg-iw01j.kiiapps.com/am/api/oauth2/token", method: .post, parameters: nil, headers: makeHeaders(), encoding: JSONEncoding.default) .responseJSON { (urlReques)t in
        //            //debugPrint(response)
        //            urlRequest.httpBody = parameters.
        //
        //
        //        }
        
        Alamofire.AF.request("https://am-stg-iw01j.kiiapps.com/am/api/oauth2/token", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON {  response in
                debugPrint(response)
            }
        
            .responseDecodable { <#DataResponse<Decodable, AFError>#> in
                <#code#>
            }
        
        
        
//        struct Category {
//            let name: String
//        }
//
//        request.responseDecodable(of: ) { response in
//            guard let categories = response.value else {
//                return
//            }
//            DispatchQueue.main.async { [weak self] in
//                self.category = categories.map(Category.init)
//                // print("\(category)")
//            }
//        }
    }
}



