//
//  DeliveryListController.swift
//  Gas
//
//  Created by Vuong The Vu on 27/09/2022.
//

import UIKit
import FloatingPanel
import Alamofire

//struct GetLatestWorkerRouteLocationListInfo: Decodable {
//    var locations: [ObjectItem]?
//    var workerRoute : workerRouteDetail
//}
//
//struct ObjectItem : Decodable {
//    var arrivalTime : arrivalTimeDetail?
//    var breakTimeSec: Int
//    var createdAt: String?
//    var latitude : Double
//    var loadCapacity: Int?
//    var loadSupply: Int
//    var location : locationDetail?
//    var locationID: Int
//    var locationOrder : Int
//    var longitude : Double
//    var metadata : metedateDetail
//    var timeWindow : String?
//    var travelTimeSecToNext : Int
//    var waitingTimeSec: Int
//    var workTimeSec: Int
//    
//}
//
//struct locationDetail : Decodable {
//    var areaID: Int?
//    var assetID: String?
//    var comment : String?
//    var createdAt : String?
//    var id : Int?
//    var importance : Int?
//    var latitude: Double?
//    var loadCapacity: Int?
//    var loadConsumeMax: Int?
//    var loadConsumeMin: Int?
//    var locationType : String?
//    var longitude: Double?
//    var metadata : metedateDetail?
//    var normalizedScore : Double?
//    var priority: String?
//    var tenantID: Int?
//    var timeWindow: String?
//    var updatedAt: Date?
//    var vehicleLimit : Int?
//    var workTimeSec: Int?
//}
//struct arrivalTimeDetail : Decodable {
//    var hours : Int?
//    var minutes : Int?
//    var nanos : Int?
//    var second : Int?
//    
//}
//struct metedateDetail : Decodable {
//    var KYOKYUSETSUBI_CODE : String?
//    var display_data : display_dataDetail?
//    var operators : [String]?
//}
//struct display_dataDetail : Decodable {
//    var delivery_history: DateInfo?
//    
//}
//struct DateInfo : Decodable {
//    var dateDetail : String?
//}
//struct workerRouteDetail: Decodable {
//         var  createdAt: String?
//         var  id: Int
//         var loadRemain: Int
//         var  routeID: Int
//         var totalTimeSec: Double
//         var workDate: Date
//         var workerID: Int
//         var workerVehicleID: Int
//}


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
    //    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "YYYY-MM-DD"
        //        dateFormatter.timeStyle = .none
        //dateFormatter.locale = Locale.current
        
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        let todaysDate = dateFormatter.string(from: date)
        
        print("aa \(companyCode ?? "0")")
        print("bb \(tenantId ?? "")")
        print("cc \(userId ?? "")")
        print("dd \(todaysDate)")
        
        getLatestWorkerRouteLocationList()
        
        
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
                    print("\(error)")
                    
                }
                
            }
        self.hideActivity()
    }
    
    let assetID = UserDefaults.standard.string(forKey: "assetID") ?? ""
    func getGetAsset() {
        self.showActivity()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode ?? "").kiiapps.com/am/api/assets/\(assetID)"
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

