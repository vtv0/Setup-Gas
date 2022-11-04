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
    //let locationName: String
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

class DeliveryListController: UIViewController , FloatingPanelControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    //let driver = ["Xe1", "Xe2", "Xe3"]
    let statusDelivery = ["Not Delivery", "All"]
    var arrGetAsset:[String] = []
    var pins: [MyPin] = []
    var coordinate: [Double] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var pickerStatus: UIPickerView!
    @IBOutlet weak var pickerDriver: UIPickerView!
    @IBOutlet weak var pickerDate: UIPickerView!
    
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
        
        pickerStatus.dataSource = self
        pickerStatus.delegate = self
        
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
        
        
        let userCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let eyeCoordinate = CLLocationCoordinate2D(latitude: 35, longitude: 139)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 700.0)
        let annotation = MKPointAnnotation()
        
        //Setup our Map View
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.addAnnotation(annotation)
        mapView.setCamera(mapCamera, animated: false)
        
        
        var pinsADay: [MyPin] = []
        let anchor = Date()
        let date: Date! = anchor
        let valueADay: [LocationElement] = dataOneDay[date] ?? []
        
        // gia tri cua 1 ngay -> locations
        //  print(valueADay.count)
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        pinsADay.removeAll()
        if valueADay.count != 0 {
            for coordinate in valueADay {
                if coordinate.latitude != nil, coordinate.longitude != nil {
                    let onePin = MyPin(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude ?? 0, longitude: coordinate.longitude ?? 0 ))
                    pinsADay.append(onePin)
                }
                
            }
            self.mapView.addAnnotations(pinsADay)
        } else {
            showAlert(message: "Không có khách hàng nào!")
        }
        
        var arrType: [String] = []
        var beforeIndex: Int
        var currentIndex: Int
        var type: String
        
        for type in valueADay {
            arrType.append(type.location?.locationType?.rawValue ?? "")
        }
        var car = 0
        for type in arrType {
            if type == "supplier" {
                if arrType[0] == "supplier" {
                    arrType.remove(at: 0)
                    
                } else {
                    car += 1
                }
            }
        }
        
        print(car)
        var arrCar: [String] = []
        for vehicle in valueADay {
            arrCar.append(vehicle.location?.locationType?.rawValue ?? "")
        }
        for i in arrCar {
            if i == "supplier" {
                if arrCar[0] == "supplier" {
                    arrCar.remove(at: 0)
                } else {
                    numberSupplier += 1
                }
            } else if i == "customer" {
                numberCustomer += 1
            }
        }
        print("customer:\(numberCustomer)")
        print("supplier:\(numberSupplier)")
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
    func sevenDay() {
        // 7day
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                dateYMD.append(date1)
            }
        }
        pickerDate.reloadAllComponents()
    }
    
    var assetID: String = ""
    // var statusDelivery: String = ""
    var locations: [LocationElement] = []
    var dataOneDay: [Date: [LocationElement]] = [:]
    
    
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
                        //  print(status)
                        self.locations = response.value?.locations ?? []
                        if countObject != 0 {
                            var locations: [LocationElement] = []
                            
                            for itemObject in self.locations {
                                
                                locations.append(itemObject)
                                if itemObject.location?.assetID != nil {
                                    self.getGetAsset(forAsset: (itemObject.location!.assetID)!)
                                } else {
                                    print("Khong co assetID-> Supplier")
                                }
                            }
                            
                            self.dataOneDay[iday] = locations
                            
                            //Số lượng xe
                            var car = 0
                            if self.locations[0].location?.locationType == .supplier {
                                self.locations.remove(at: 0)
                            }
                            var locationsByDriver: [Int: [LocationLocation]]
                            var beforeIdx: Int = 0;
                            var currentIdx: Int = 0;
                            for location in locations {
                                if (location.location?.locationType == .supplier) {
                                    // currentIdx = ???
                                    currentIdx = numberSupplier.index
                                    locationsByDriver[beforeIdx] = locations[beforeIdx..<currentIdx]
                                    beforeIdx=currentIdx
                                }
                            }
                            //self.dataOneDay[iday][driver] = locationsByDriver[driver]
//                            in locations {
//                                if vehicle.location?.locationType == .supplier {
//                                    if self.locations[0].location?.locationType == .supplier  {
//                                        self.locations.remove(at: 0)
//                                    } else {
//                                        car = car + 1
//                                    }
//                                }
//                                print("CAR:\(car)")
//                            }
                            
                            //                            func car() {
                            //                                var carDic: [String: [Double]]
                            //                            }
                            
                            //trạng thái
                            // var statusValue : Date
                            //var arrKeyDate: [String] = []
                            //var dic: [String: String] = [:]
                            //var stringValue: String
                            
                            
                            
                            
                            
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
    
    func getGetAsset(forAsset iassetID: String) {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetAsset.self ) { response1 in
                // print("Status GetAsset:\( response1.response?.statusCode ?? 0)")
                switch response1.result {
                case .success(_):
                    self.coordinate = response1.value?.geoloc?.coordinates ?? []
                    let pinsGas1: MyPin = MyPin(coordinate: CLLocationCoordinate2D(latitude: self.coordinate[1], longitude: self.coordinate[0] ) )
                    self.pins.append(pinsGas1)
                    
                case .failure(let error):
                    print("\(error)")
                }
            }
        self.hideActivity()
    }
    //    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    //        <#code#>
    //    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerStatus {
            return statusDelivery.count
        } else if pickerView == pickerDriver {
            
            return numberSupplier
        } else if pickerView == pickerDate {
            return dateYMD.count
        }
        return 0
    }
    
    var arrStringDate: [String] = []
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerStatus {
            return statusDelivery[row]
        } else if pickerView == pickerDriver {
            return "Car"
        } else if pickerView == pickerDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            let dateString: String = formatter.string(from: dateYMD[row])
            return dateString
        }
        return ""
    }
    
    func getDataFiltered(arr: [Date: [LocationElement]], status: String, driver: String, date: Date ) -> [Data] {
        let locationsOnDate: [LocationElement] = dataOneDay[date] ?? []
        // Check thang dau la supplier thi remove thang dau di
        // Duyet
        
        
        //        var pinsADay: [MyPin] = []
        //        let date: Date! = dateYMD[1]
        //        let valueADay: [LocationElement] = dataOneDay[date] ?? []
        //
        //        print( valueADay)
        
        
        return []
    }
    
    var numberSupplier: Int = 0
    var numberCustomer: Int = 0
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var pinsADay: [MyPin] = []
        let date: Date! = dateYMD[row]
        let valueADay: [LocationElement] = dataOneDay[date] ?? []
        if pickerView == pickerDate {
            let annotations = mapView.annotations
            mapView.removeAnnotations(annotations)
            pinsADay.removeAll()
            if valueADay.count != 0 {
                for coordinate in valueADay {
                    if coordinate.latitude != nil, coordinate.longitude != nil {
                        let onePin = MyPin(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude ?? 0, longitude: coordinate.longitude ?? 0 ))
                        pinsADay.append(onePin)
                    }
                }
            } else {
                showAlert(message: "Không có khách hàng nào!")
            }
            self.mapView.addAnnotations(pinsADay)
            
            
        } else if pickerView == pickerDriver {
            //print("picker driver")
            let date: Date! = dateYMD[1]
            let valueADay: [LocationElement] = dataOneDay[date] ?? []
       
//            var arrCar: [String] = []
//            for vehicle in valueADay {
//                arrCar.append(vehicle.location?.locationType?.rawValue ?? "")
//
//            }
          //  print(arrCar)
//            var numberSupplier: Int = 0
//            var numberCustomer: Int = 0
//            for i in arrCar {
//                if i == "supplier" {
//                    if arrCar[0] == "supplier" {
//                        arrCar.remove(at: 0)
//
//                    } else {
//                        numberSupplier += 1
//                    }
//                } else if i == "customer" {
//                    numberCustomer += 1
//                }
//            }
//
//            print("customer:\(numberCustomer)")
//            print("supplier:\(numberSupplier)")
            
        } else if pickerView == pickerStatus {
            let date: Date! = dateYMD[row]
            let valueADay: [LocationElement] = dataOneDay[date] ?? []
            var pinsStatusAll: [MyPin] = []
            var pinsStatusNotDelivery: [MyPin] = []
            let annotations = mapView.annotations
            mapView.removeAnnotations(annotations)
            //  pinsStatusAll.removeAll()
            for statusShipping in valueADay {
                if statusShipping.latitude != nil && statusShipping.longitude != nil && statusShipping.location?.metadata?.displayData?.valueDeliveryHistory() == .waiting  {
                    let onePin = MyPin(coordinate: CLLocationCoordinate2D(latitude: statusShipping.latitude!, longitude: statusShipping.longitude! ))
                    pinsStatusNotDelivery.append(onePin)
                    mapView.addAnnotations(pinsStatusNotDelivery)
                } else {
                    let onePin = MyPin(coordinate: CLLocationCoordinate2D(latitude: statusShipping.latitude!, longitude: statusShipping.longitude! ))
                    pinsStatusAll.append(onePin)
                    mapView.addAnnotations(pinsStatusAll)
                }
            }
        }
    }
    
}

extension DeliveryListController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MyPin else { return nil }
        // let identifier = "Annotation"
        var view: MyPinView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation") as? MyPinView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MyPinView(annotation: annotation, reuseIdentifier: "Annotation")
            //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
