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
    //    var SevenDay = UserDefaults.standard.stringArray(forKey: "SevenDay")
    var arrGetAsset:[String] = []
    var pins: [MyPin] = []
    var coordinate: [Double] = []
    
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
        
        //navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // Set initial location in Honolulu
        //let initialLocation = CLLocation(latitude: 18.683500, longitude: 105.485750)
        
        //  let initialLocation = CLLocationCoordinate2DMake( 18.683500, 105.485750)
        // mapView.centerToLocation(initialLocation)
        
        self.addAnnotation()
        
        let userCoordinate = CLLocationCoordinate2D(latitude: 35.672855, longitude: 139.817413)
        let eyeCoordinate = CLLocationCoordinate2D(latitude: 35.672855, longitude: 35.672855)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 400.0)
        let annotation = MKPointAnnotation()
        
        //Setup our Map View
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.addAnnotation(annotation)
        mapView.setCamera(mapCamera, animated: false)
    }
    
    func showAlert(title: String? = "", message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    
    
    var dateYMD: [Date] = []
    //var dateMMdd : [String] = []
    func sevenDay() {
        // 7day
        let anchor = Date()
        let calendar = Calendar.current
        //let mmdd = DateFormatter()
        //mmdd.dateFormat = "MM/dd"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                dateYMD.append(date1)
             //   let mmdd = mmdd.string(from: date1)
              //  dateMMdd.append(mmdd)
            }
        }
    }
    
    var assetID: String = ""
    var statusDelivery: String = ""
    var locations: [LocationElement] = []
    var dataOneDay: [Date: [LocationElement]] = [:]
    var locationElements: [LocationElement] = []
    
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
                    case .success(let status):
                        
                        let countObject = response.value?.locations?.count
                        print("Có: \(countObject ?? 0) OBJECT")
                        //  print(status)
                        self.locations = response.value?.locations ?? []
                        if countObject != 0 {
                            var locationElements: [LocationElement] = []
                            for itemObject: LocationElement in self.locations {
                                locationElements.append(itemObject)
                                if (itemObject.location?.assetID != nil) {
                                    self.getGetAsset(forAsset: (itemObject.location!.assetID)!)
                                } else {
                                    print("Khong co assetID-> Supplier")
                                }
                            }
                            
                            self.dataOneDay[iday] = locationElements
                            //  print("\(self.dataOneDay.values.description)")
                            //Số lượng xe
                            var xe = 0
                            for vehicle in locationElements {
                                if vehicle.location?.locationType == "supplier"  {
                                    if self.locations[0].location?.locationType == "supplier"  {
                                        self.locations.remove(at: 0)
                                    } else {
                                        xe = xe + 1
                                    }
                                }
                                // print("XE:\(xe)")
                            }
                            //trạng thái
                            // var statusValue : Date
                            //var arrKeyDate: [String] = []
                            //var dic: [String: String] = [:]
                            //var stringValue: String
                            
                            var t1: Int = 0
                            var t2: Int = 0
                            
                            for statusShipping in locationElements {
                                // var dic = statusShipping.location?.metadata?.displayData?.delivery_history ?? [:]
                                // statusShipping.location?.metadata?.displayData?.valueDeliveryHistory()
                                
                                if (statusShipping.location?.metadata?.displayData?.valueDeliveryHistory()) != nil {
                                    t1 += 1
                                } else {
                                    t2 += 1
                                }
                                // print("t1:\(t1)")
                                //  print("t2:\(t2)")
                                
                            }
                            //tong = t1 + t2
                            print("tong = \(t1) + \(t2)")
                            
                            
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
        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetAsset.self ) { response1 in
                // print("Status GetAsset:\( response1.response?.statusCode ?? 0)")
                switch response1.result {
                case.success(_):
                    self.coordinate = response1.value?.geoloc?.coordinates ?? []
                    //print("  \(self.coordinate[1]) , \(self.coordinate[0])   ")
                    
                    //    let pinsGas1: MyPin = MyPin(coordinate: CLLocationCoordinate2D(latitude: self.coordinate[1], longitude: self.coordinate[0] ) )
                    self.pins.append(MyPin(coordinate: CLLocationCoordinate2D(latitude: self.coordinate[1], longitude: self.coordinate[0] ) ))
                    //  print("_ok.....\(urlGetAsset) ")
                    self.mapView.addAnnotations(self.pins)
                case .failure(let error):
                    print("\(error)")
                }
            }
        self.hideActivity()
    }
}

extension DeliveryListController: MKMapViewDelegate {
    
    func addAnnotation() {
        let annotation = MKPointAnnotation()
        let marker = mapView.view(for: annotation)
        marker?.image = UIImage(named: "marker")
        
        //annotation.coordinate = CLLocationCoordinate2D(latitude: 18.683500, longitude: 105.485750)
        mapView.mapType = .hybridFlyover
        mapView.addAnnotation(annotation)
        mapView.addAnnotations(self.pins)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MyPin else { return nil }
        let identifier = "Annotation"
        var view: MyPinView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MyPinView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MyPinView(annotation: annotation, reuseIdentifier: identifier)
            //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

extension DeliveryListController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    for iday in dateYMD {
        let dateString: String = formatter.string(from: iday)
    }
    
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
            return dateYMD[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 2) {
            for date1 in dateYMD {
                i =
            }
        
            if (dateMMdd[row] == "11/08") {
                
                let sortArrKey = self.dataOneDay.keys.sorted(){$0 < $1}
                if let firstKey = sortArrKey.last {
                    print(firstKey)
                    let value = dataOneDay[firstKey]
                    value
                    mapView.
                    
                    print(value?.count ?? 0)
                }
            }
            // print("dung pickerview\(mapView.annotations.count)")
            //   showDataDay.text = locations
            // showDataDay.text = dateYMD[row]
        }
    }
}


