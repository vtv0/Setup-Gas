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
    
    //let status = ["chua", "tat ca"]
    
    //let locations  = UserDefaults.standard.object(forKey: "Locations") ?? []
    
    let pins: [MyPin] = [
        MyPin(coordinate: CLLocationCoordinate2D(latitude: 16.071763, longitude: 108.223963)),
        MyPin(coordinate: CLLocationCoordinate2D(latitude: 16.074443, longitude: 108.224443)),
        MyPin(coordinate: CLLocationCoordinate2D(latitude: 16.073969, longitude: 108.228798)),
        MyPin(coordinate: CLLocationCoordinate2D(latitude: 16.069783, longitude: 108.225086)),
        MyPin(coordinate: CLLocationCoordinate2D(latitude: 16.070629, longitude: 108.228563))
    ]
    
    //    var SevenDay = UserDefaults.standard.stringArray(forKey: "SevenDay")
    var arrGetAsset:[String] = []
    
    //    @IBOutlet weak var showDataDay: UILabel!
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
        super.viewDidLoad()
        
        self.sevenDay()
        getLatestWorkerRouteLocationList()
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
    
    var dateYMD: [Date] = []
    var dateMMdd : [String] = []
    func sevenDay() {
        // 7day
        let anchor = Date()
        let calendar = Calendar.current
        let mmdd = DateFormatter()
        mmdd.dateFormat = "MM/dd"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                dateYMD.append(date1)
                
                let mmdd = mmdd.string(from: date1)
                dateMMdd.append(mmdd)
            }
        }
    }
    
    var assetID: String = ""
    var statusDelivery: String = ""
    
    var locations: [LocationElement] = []
    
    var dataOneDay: [Date: [LocationElement]] = [:]
    
    //var valueDic : [LocationElement] = []
    
    func getLatestWorkerRouteLocationList() {
        self.showActivity()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        for iday in dateYMD {
            let dateString: String = formatter.string(from: iday)
            let url:String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(dateString)"
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default ,headers: self.makeHeaders(token: token))
                .responseDecodable(of: GetLatestWorkerRouteLocationListInfo.self) { response in
                    print("\(url)::::>\( response.response?.statusCode ?? 0)")
                    
                    switch response.result {
                    case .success(_):
                        
                        let countObject = response.value?.locations?.count
                        print("Có: \(countObject ?? 0) OBJECT")
                        
                        self.locations = response.value?.locations ?? []
                        
                        
                        if countObject != 0 {
                            
                            var locationElements: [LocationElement] = []
                            
                            for itemObject: LocationElement in self.locations {
                                // Ngay nao
                                // Mang locations
                                //                             let litemObject: LocationElemen
                                locationElements.append(itemObject)
                                
                                // lay lattitude, longtitude
                                let lat = itemObject.location?.latitude
                                
                                
                                //  print("\(lat)")
                                //lay assetID
                                if (itemObject.location?.assetID != nil) {
                                    self.getGetAsset(forAsset: (itemObject.location!.assetID)!)
                                } else {
                                    //   print("Khong co assetID")
                                }
                                if ((itemObject.location?.metadata?.displayData) != nil) {
                                    //  print("tat ca")
                                } else {
                                    //  print("chua giao")
                                }
                                //                                }
                                //                                    if ((itemObject.location?.locationType ) != nil) {
                                //                                        print("\(itemObject.location?.locationType.self)")
                                //                                    }
                                
                                //let statusDelivery = itemObject.location?.metadata?.displayData?.deliveryHistory
                                // print("ssssss:\(statusDelivery)")
                                var t = 0
                                if self.statusDelivery != nil {
                                    t += 1
                                    //  print("\(statusDelivery)")
                                }
                                
                            }
                            
                            self.dataOneDay[iday] = locationElements
                            //  print("\(self.dataOneDay.values.description)")
                            //Số lượng xe
                            var xe = 0
                            for vehicle in locationElements {
                                if vehicle.location?.locationType?.description == "supplier"  {
                                    if self.locations[0].location?.locationType?.description == "supplier"  {
                                        self.locations.remove(at: 0)
                                    } else {
                                        xe = xe + 1
                                    }
                                }
                                // print("XE:\(xe)")
                            }
                            
                            //trạng thái
                            var statusValue : String
                            var arrKeyDate: [String] = []
                            var dic: [String: String] = [String: String]()
                            for statusShipping in locationElements {
                                dic = statusShipping.location?.metadata?.displayData?.deliveryHistory ?? [:]
                                // print("222222::\(statusShipping.location?.metadata?.displayData?.deliveryHistory?.keys )")
                                //  print("333333::\(statusShipping.location?.metadata?.displayData?.deliveryHistory?.keys.sorted() )")
                                //  var keyy = statusShipping.location?.metadata?.displayData?.deliveryHistory?.keys.sorted()
                                //  print("444444::\(statusShipping.location?.metadata?.displayData?.deliveryHistory?[keyy] )")
                                for key in (dic.keys) {
                                    arrKeyDate.append(key)
                                    print("00000: \(arrKeyDate)")
                                }
                                
                                let sortedArray = arrKeyDate.sorted {$0.compare($1, options: .numeric) == .orderedDescending}
                                // print("jjjjjjjj:\( sortedArray)\n")
                                
                                //let firstKey = sortedArray.
                                // print("ffffffff:\(firstKey ?? "")")
                                //print("kkkkkkkk:\( statusShipping.location?.metadata?.displayData?.deliveryHistory?[firstKey ?? ""]) ")
                                // statusValue = statusShipping.location?.metadata?.displayData?.deliveryHistory?[firstKey ?? ""] as? String ?? ""
                                // print("STSTS:\(statusValue)")
                            }
                        } else  {
                            print(response.response?.statusCode as Any)
                            print("\(url) =>> Array Empty ")
                        }
                        
                    case .failure(let error): // bị lặp lại 7 lần
                        if( response.response?.statusCode == 401) {
                            self.hideActivity()
                            let src = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                            self.navigationController?.pushViewController(src, animated: true)
                        }
                        print("Error: \(response.response?.statusCode ?? 000000)")
                        print("\(error)")
                    }
                }
        }
        
    }
    
    func getGetAsset(forAsset iassetID:String) {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeaders(token: token)) .response { response1 in
            // print("\(urlGetAsset)")
            // print("Status GetAsset:\( response1.response?.statusCode ?? 0)")
            //            var arr = response1.value?.properties?.values?.display_data.delivery_history
            //            print("99999:\(arr)")
            switch response1.result {
            case.success(_):
                //lấy trạng thái mới nhất của từng Object -> [tatca, chua giao]
            
                //for statusDeliveryHistory in response1.pro//
                
                // self.hideActivity()
                print("--ok'''''\(urlGetAsset) ")
                
            case .failure(let error):
                print("\(error)")
            }
        }
        self.hideActivity()
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
            //   return status22.count
        } else if (pickerView.tag == 1) {
            return driver.count
        } else if (pickerView.tag == 2) {
            return dateMMdd.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ( pickerView.tag == 0) {
            //  return status22[row]
        } else if (pickerView.tag == 1) {
            return driver[row]
        } else if (pickerView.tag == 2) {
            return dateMMdd[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 2) {
            
            //  print("\(Itemobeject)")
            // print("\(valueDic.count)")
            print("dung pickerview")
            //   showDataDay.text = locations
            // showDataDay.text = dateYMD[row]
            
        }
        
        
    }
}
