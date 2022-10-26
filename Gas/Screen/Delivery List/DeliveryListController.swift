//
//  DeliveryListController.swift
//  Gas
//
//  Created by Vuong The Vu on 27/09/2022.
//

import UIKit
import FloatingPanel
import Alamofire
import MapKit

class MyPin: NSObject, MKAnnotation {
    //let title: String?
    // let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init( coordinate: CLLocationCoordinate2D) {
        //        self.title = title
        //        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    //    var subtitle: String? {
    //        return locationName
    //    }
}

class DeliveryListController: UIViewController , FloatingPanelControllerDelegate {
    
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    let driver = ["Xe1", "Xe2", "Xe3"]
    var date: [String] = []
    let status = ["chua", "tat ca"]
    
    let pins: [MyPin] = [
        MyPin(coordinate: CLLocationCoordinate2D(latitude: 16.071763, longitude: 108.223963)),
        MyPin(coordinate: CLLocationCoordinate2D(latitude: 16.074443, longitude: 108.224443)),
        MyPin(coordinate: CLLocationCoordinate2D(latitude: 16.073969, longitude: 108.228798)),
        MyPin(coordinate: CLLocationCoordinate2D(latitude: 16.069783, longitude: 108.225086)),
        MyPin(coordinate: CLLocationCoordinate2D(latitude: 16.070629, longitude: 108.228563))
    ]
    let OneDay = UserDefaults.standard.string(forKey: "OneDay") ?? ""
    let SevenDay = UserDefaults.standard.stringArray(forKey: "SevenDay")
    let assetID = UserDefaults.standard.string(forKey: "AssetID") ?? ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerDriver: UIPickerView!
    @IBOutlet weak var pickerDate: UIPickerView!
    
    
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
    
//    let dict : [String: [String]] = ["2022-11-01": ["th.7b3f20b00022-4abb-ce11-bebd-8ff430d9","th.bc65e7a00022-8048-ce11-bebd-616b79f9",
//                                      "th.bc65e7a00022-8048-ce11-bebd-7c6fc30a"] ]
//    UserDefaults.standard.setValue(dict, forKey: "Dict1")
//    let data = UserDefaults.standard.string(forKey: "Dict1")
    override func viewDidLoad() {
        
        

        let dictionary: [String: [String]] = ["2022-11-01": ["th.7b3f20b00022-4abb-ce11-bebd-8ff430d9","th.bc65e7a00022-8048-ce11-bebd-616b79f9",
                                                             "th.bc65e7a00022-8048-ce11-bebd-7c6fc30a"] ] //Dictionary which you want to save

        UserDefaults.standard.setValue(dictionary, forKey: "DictValue") //Saved the Dictionary in user default

        let dictValue = UserDefaults.standard.value(forKey: "DictValue") //Retrieving the value from user default

       // print(dictValue)  // Printing the value
        
       
        print("..........\(dictValue ?? [])")
               
        super.viewDidLoad()
        self.sevenDay()
        getLatestWorkerRouteLocationList()
        getGetAsset()
        
        print("aa \(companyCode )")
        print("bb \(tenantId )")
        print("cc \(userId )")
        
        //        let fpc = FloatingPanelController()
        //        fpc.delegate = self
        //        guard let contentDeliveryVC = storyboard?.instantiateViewController(withIdentifier: "FloatingPanelDeliveryVC") as? FloatingPanelDeliveryVC else { return }
        //
        //        let countPage = ["a","c","3"]
        //        contentDeliveryVC.data = countPage
        //        fpc.set(contentViewController: contentDeliveryVC)
        //        fpc.addPanel(toParent: self)
        // fpc.trackingScrollView
        
        picker.dataSource = self
        picker.delegate = self
        
        pickerDriver.dataSource = self
        pickerDriver.delegate = self
        
        pickerDate.dataSource = self
        pickerDate.delegate = self
        
        view.bringSubviewToFront(btnShipping)
        
         navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // Set initial location in Honolulu
        //let initialLocation = CLLocation(latitude: 18.683500, longitude: 105.485750)
        
        //  let initialLocation = CLLocationCoordinate2DMake( 18.683500, 105.485750)
        // mapView.centerToLocation(initialLocation)
        
        self.addAnnotation()
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func addAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 18.683500, longitude: 105.485750)
        annotation.title = "Point 0001"
        annotation.subtitle = "subtitle 0001"
        mapView.mapType = .hybrid
        mapView.addAnnotation(annotation)
        mapView.addAnnotations(pins)
    }
    
    func sevenDay() {
        // 7day
        let anchor = Date()
        let calendar = Calendar.current
        let mmdd = DateFormatter()
        mmdd.dateFormat = "MM-dd"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //formatter.dateFormat = "MM/dd"
        date = []
        
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                let day = formatter.string(from: date1)
                date.append(day)
                UserDefaults.standard.set(date, forKey: "SevenDay")
            }
        }
        print("001.\( UserDefaults.standard.stringArray(forKey: "SevenDay") ?? [])")
    }
    
    
    
    func getLatestWorkerRouteLocationList() {
        self.showActivity()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        for iday in SevenDay! {
          //  print("==>\(iday)")
            let url:String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(iday)"
           // let url:String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=2022-10-27"
        //    print(url)
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default ,headers: self.makeHeaders(token: token))
                .responseDecodable (of: GetLatestWorkerRouteLocationListInfo.self) { response in
                    print("Status code LatestWorkerRouteLocationList 7ngay:\( response.response?.statusCode ?? 0)")
                    print("Ngay: ", url)
                    
                    switch response.result {
                    case .success(_):
                        
                        let countObject = response.value?.locations.count
                        print("Có: \(countObject ?? 0) OBJECT")
//                let assetID = response.value?.locations.location?.assetID
//                UserDefaults.standard.set(assetID, forKey: "AssetID")
                        let locations: [LocationElement] = response.value?.locations ?? []
                        
                        if countObject != 0 {
                            for itemObject in  locations {
                              //  print(item.location?.assetID)
                                
                                let assetID1 : String = itemObject.location?.assetID ?? ""
                               // let assetID1  = itemObject.location?.assetID
                                //print("Asset: \(assetID1)")// in ra assetID của từng object
                                
//                                let status = item.location?.metadata.displayData?.deliveryHistory
//                                print(status ?? "") //4 trạng thái inprogress, failed, complete , không có gì
                                var arrayAssetID: [String] = []
                               // print(self.array)
                                if assetID1 != "" {
                                    arrayAssetID.append(assetID1)
                                    print("Array++: \(arrayAssetID)") // Muốn lưu thành mảng assetID theo từng ngày
                                    
                                    UserDefaults.standard.set(arrayAssetID,forKey: "ArrAssetID") //Lưu từng mảng theo ngày vào -> UserDefaults
                                    
                                    //print(arrayAssetID)
                                   // assetIDCurently.append(item.location?.assetID ?? "")
                                   // self.getGetAsset()
                                   
                                } else {
                                    print("\(assetID1)-------------------------> nil ")//không có assetID(th.xxxxxxxx)
                                }
                            }
                        } else  {
                            print("\(url) => Array Empty ")
                        }

                    case .failure(_):
                        if( response.response?.statusCode == 401) {
                            let src = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                            self.navigationController?.pushViewController(src, animated: true)
                        }
                        print("loi: \(response.response?.statusCode ?? 0)")
                    }
                    self.hideActivity()
                }
        }
      
    }
   
    
    let array = UserDefaults.standard.stringArray(forKey: "ArrAssetID") ?? [] // Lấy data từ UserDefaults.
//
    func getGetAsset() {

        //self.showActivity()
        for iassetID in array {
            print("ZZZZZZZZZZZZZ: \(iassetID)")
        }
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/th.4fc297a00022-94d8-ce11-bebd-75c70db5"
        print("assetID: \(assetID)")
        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeaders(token: token)) .response { response1 in
            print("Status GetAsset:\( response1.response?.statusCode ?? 0)")
            switch response1.result {
            case.success(_):
               
                print("oooooooook: \(urlGetAsset)")
                self.hideActivity()
            case .failure(let error):
                print("\(error)")
            }
            
        }
        
    }
    
    
    func showAlert(title: String? = "", message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
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
            return date.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ( pickerView.tag == 0) {
            return status[row]
        } else if (pickerView.tag == 1) {
            return driver[row]
        } else if (pickerView.tag == 2) {
            return date[row]
        }
        return ""
    }
}

