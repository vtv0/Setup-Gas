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
    
    @IBOutlet weak var picker: UIPickerView!
    let status = ["chua", "tat ca"]
    @IBOutlet weak var pickerDate: UIPickerView!
    let date1 = ["03/10", "04/10", "05/10", "06/10","07/10","08/10","09/10"]
    
    @IBOutlet weak var pickerDriver: UIPickerView!
    let driver = ["Xe1", "Xe2", "Xe3"]
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""

    public func oneDay() {
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        let todaysDate = dateFormatter.string(from: date)
        print("today:\(todaysDate)")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getLatestWorkerRouteLocationList()
       // self.oneDay()
        //1day
        
        
        print("aa \(companyCode )")
        print("bb \(tenantId )")
        print("cc \(userId )")
        
        // 7day
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                let sevenday = formatter.string(from: date)
                print("dddd:\(sevenday)")
            }
        }
        
       
        let fpc = FloatingPanelController()
        fpc.delegate = self
        guard let contentDeliveryVC = storyboard?.instantiateViewController(withIdentifier: "FloatingPanelDeliveryVC") as? FloatingPanelDeliveryVC else { return }
        
        let countPage = ["a","c","3"]
        // let countPage = [UserDefaults.standard.string(forKey: "CountPage")]
        //print("\(UserDefaults.standard.string(forKey: "CountPage"))")
        
        contentDeliveryVC.data = countPage
        //UserDefaults.standard.value(forKey: "CountPage") as! [String]
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
    
    
    
    func getLatestWorkerRouteLocationList() {
        self.showActivity()
        self.oneDay()
        //self.print("today:\(todaysDate)")
        
        let url:String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=2022-10-26"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default ,headers: self.makeHeaders(token: token))
            .responseDecodable (of: GetLatestWorkerRouteLocationListInfo.self) { response in
                print("Status code LatestWorkerRouteLocationList:\( response.response?.statusCode ?? 0)")
                switch response.result {
                case .success(_):
                    let countPage1 = response.value?.locations.count
                    //UserDefaults.standard.set(countPage1, forKey: "CountPage")
                    print("ssss",countPage1 ?? "")
                    let assetID = [response.value?.locations[1].location.assetID]
                    UserDefaults.standard.set(assetID, forKey: "assetID")
                    print("===>\(assetID ) ")
                    self.getGetAsset()
                   
                case .failure(let error):
                    if( response.response?.statusCode == 401) {
                        let src = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                        self.navigationController?.pushViewController(src, animated: true)
                    }
                    print("\(error)")
                    
                }
                
            }
        self.hideActivity()
    }
    
    let assetID = UserDefaults.standard.string(forKey: "assetID") ?? ""
    func getGetAsset() {
        self.showActivity()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(assetID)"
        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeaders(token: token)) .response { response1 in
            print("Status GetAsset:\( response1.response?.statusCode ?? 0)")
            switch response1.result {
            case.success(_):
                print("ok")
                self.hideActivity()
            case .failure(let error):
                print("\(error)")
            }
            self.hideActivity()
        }
    }
}

extension DeliveryListController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            return status.count
        } else if (pickerView.tag == 1) {
            return driver.count
        } else if (pickerView.tag == 2) {
            return date1.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ( pickerView.tag == 0) {
            return status[row]
        } else if (pickerView.tag == 1) {
            return driver[row]
        } else if (pickerView.tag == 2) {
            return date1[row]
        }
        return ""
    }
}

