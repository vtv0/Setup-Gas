//
//  DeliveryListController.swift
//  Gas
//
//  Created by Vuong The Vu on 27/09/2022.
//

import UIKit
import FloatingPanel
import Alamofire

class DeliveryListController: UIViewController , FloatingPanelControllerDelegate {
    
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var driverPicker: UIPickerView!
    @IBOutlet weak var btnShipping: UIButton!
    @IBAction func btnShipping(_ sender: Any) {
        print("click Shipping tren MH chinh")
        let alert = UIAlertController(title: "Lỗi", message: "Có một địa chỉ giao hàng được chỉ định", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //static let image = #imageLiteral(resou
    
    @IBOutlet weak var picker: UIPickerView!
    let data = ["1", "2", "3", "4", "5", "6"]
    
    
    @IBOutlet weak var pickerDate: UIPickerView!
    let date = ["03/10", "04/10", "05/10", "06/10","07/10","08/10","09/10"]
    
    @IBOutlet weak var pickerDriver: UIPickerView!
    let driver = ["n1", "n2", "n3"]
    
        func getLatestWorkerRouteLocationList() {
            let dateFormatterGet = DateFormatter()
            let workDate = dateFormatterGet.string(from: Date())
            
            //{{exBaseUrl}}/vrp/tenants/{{tenantID}}/latest_route/worker_users/{{userID}}?workDate={{workDate}}
            let url: String = "https://am-stg-iw01j.kiiapps.com/am/exapi/vrp/tenants/18/latest_route/worker_users/39?workDate=2022-10-21"
           //let  urlGetLatestWorkerRouteLocationList = urlGetLatestWorkerRouteLocationList + "\(UserDefaults.standard.string(forKey: "tenantId"))/latest_route/worker_users/\(UserDefaults.standard.string(forKey: "userId"))?workDate=\(workDate)"
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
                .responseDecodable(of: GetMeInfo.self) { response in
                   print("jjj\(response.response?.statusCode)")
    
                }
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLatestWorkerRouteLocationList()
       // title = "Delivery List"
        let fpc = FloatingPanelController()
        fpc.delegate = self
        guard let contentDeliveryVC = storyboard?.instantiateViewController(withIdentifier: "FloatingPanelDeliveryVC") as? FloatingPanelDeliveryVC else { return }
        contentDeliveryVC.data = data
        fpc.set(contentViewController: contentDeliveryVC)
        fpc.addPanel(toParent: self)
       // fpc.trackingScrollView
        
        picker.dataSource = self
        picker.delegate = self
        
        pickerDriver.dataSource = self
        pickerDriver.delegate = self
        
        pickerDate.dataSource = self
        pickerDate.delegate = self
        
        
        view.bringSubviewToFront(btnShipping)
       navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    
    
    @IBAction func btnSetting(_ sender: Any) {
        let screenSetting = storyboard?.instantiateViewController(withIdentifier: "SettingController") as! SettingController
        //present(screenSetting, animated: true, completion: nil)
        self.navigationController?.pushViewController(screenSetting, animated: true)
    }
    @IBAction func btnReplan(_ sender: Any) {
        let screenReplan = storyboard?.instantiateViewController(withIdentifier: "ReplanController") as! ReplanController
        self.navigationController?.pushViewController(screenReplan, animated: true)
    }
    @IBAction func btnReroute(_ sender: Any) {
        let screenReroute = storyboard?.instantiateViewController(withIdentifier: "RerouteViewController") as! RerouteViewController
        self.navigationController?.pushViewController(screenReroute, animated: true)
    }
}

extension DeliveryListController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            return data.count
        } else if (pickerView.tag == 1) {
            return driver.count
        } else if (pickerView.tag == 2) {
            return date.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ( pickerView.tag == 0) {
            return data[row]
        } else if (pickerView.tag == 1) {
            return driver[row]
        } else if (pickerView.tag == 2) {
            return date[row]
        }
        return ""
    }
}
