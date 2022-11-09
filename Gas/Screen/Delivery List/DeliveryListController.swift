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
import Network

class CustomPin: NSObject, MKAnnotation {
    let title: Int
    //let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    init(title: Int, coordinate: CLLocationCoordinate2D) {
        self.title = title
        //  self.locationName = locationName
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
    var arrGetAsset: [String] = []
    var pins: [CustomPin] = []
    var coordinate: [Double] = []
    var selectedIdxDate: Int = 0
    var selectedIdxDriver: Int = 0
    var selectesIdxStatus: Int = 0
    
    var arr: [Int] = []
    var pinsADay: [CustomPin] = []
    var dicData: [Date : [LocationElement]] = [:]
    
    var indxes: [Int] = []
    var assetID: String = ""
    var locations: [LocationElement] = []
    
    
    
    @IBOutlet weak var lblType50kg: UILabel!
    @IBOutlet weak var lblType30kg: UILabel!
    @IBOutlet weak var lblType25kg: UILabel!
    @IBOutlet weak var lblType20kg: UILabel!
    @IBOutlet weak var lblOtherType: UILabel!
    
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
        
        
        let userCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let eyeCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 100000.0)
        
        
        //Setup our Map View
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        //        mapView.addAnnotation(annotation)
        mapView.setCamera(mapCamera, animated: false)
        
        
        //            selectedIdxDate = 0
        //            let date: Date! = dateYMD[0]
        //            let valueADay: [LocationElement] = dicData[date] ?? []
        //            var arrCar: [String] = []
        //            for vehicle in valueADay {
        //                arrCar.append(vehicle.location?.locationType?.rawValue ?? "")
        //                if arrCar[0] == "supplier" {
        //                    arrCar.remove(at: 0)
        //                }
        //            }
        //            let indxes1: [Int] = arrCar.enumerated().filter{ $0.element == "supplier" }.map{ $0.offset }
        //            indxes = indxes1
        //            self.pickerDriver.reloadAllComponents()
        //            selectedIdxDriver = 0
        //            let locationsFiltered = self.getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver, status: selectesIdxStatus)
        //            self.reDrawMarkers()
        
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
                        //  print("Có: \(countObject ?? 0) OBJECT")
                        //  print(status)
                        self.locations = response.value?.locations ?? []
                        if countObject != 0 {
                            var locations: [LocationElement] = []
                            for itemObject in self.locations {
                                locations.append(itemObject)
                                if itemObject.location?.assetID != nil {
                                    self.getGetAsset(forAsset: (itemObject.location!.assetID)!, locationOrder: itemObject.locationOrder )
                                } else {
                                    print("Khong co assetID-> Supplier")
                                }
                            }
                            
                            // value cua Dic key la ngay
                            self.dicData[iday] = locations
                            // Số lượng xe, tach xe
                            // var arrSupplier: [LocationLocation] = []
                            var tmpArr = locations
                            
                            // Gia dinh da xoa thang supplier dau tien
                            var arrCar: [String] = []
                            for vehicle in locations {
                                arrCar.append(vehicle.location?.locationType?.rawValue ?? "")
                                if arrCar[0] == "supplier" {
                                    arrCar.remove(at: 0)
                                } else {
                                    let indxes: [Int] = arrCar.enumerated().filter { $0.element == "supplier" }.map { $0.offset }
                                    
                                    for (idx, item) in indxes.enumerated() {
                                        if Array(self.locations) != nil {
                                            if (idx == 0) {
                                                tmpArr = (Array(self.locations[0...indxes[0]]) as AnyObject) as! [LocationElement]
                                            } else {
                                                tmpArr = (Array(self.locations[indxes[idx-1]+1...indxes[idx]]) as AnyObject) as! [LocationElement]
                                            }
                                        }
                                        // print("\n\n\n\n\n\n\nxxx", tmpArr)
                                        //self.locationsByDriver[idx] = tmpArr as? [LocationElement]
                                    }
                                }
                            }
                            print(arrCar )
                            
                            
                            
                            
                            self.pickerDriver.reloadAllComponents()
                            
                            //                            for location in locations {
                            //                                if (location.location?.locationType == .supplier) {
                            //
                            //                                    beforeIdx = indxes.startIndex
                            //                                    currentIdx = indxes[beforeIdx + 1]
                            //                                    let arrTemp: [LocationElement] = Array(self.locations[beforeIdx..<currentIdx])
                            //
                            //                                   // print(beforeIdx)
                            //                                   // print(currentIdx)
                            //                                    print("\(beforeIdx), \(currentIdx), \(arrTemp)")
                            //
                            //                                    beforeIdx = currentIdx
                            //                                   // currentIdx = ind[beforeIdx + 1]
                            //
                            //                                    print(beforeIdx)
                            //                                }
                            //                            }
                            
                            //trạng thái
                            // var statusValue : Date
                            //var arrKeyDate: [String] = []
                            //var dic: [String: String] = [:]
                            //var stringValue: String
                            
                            
                            // MARK: - Display Number For Each Type
                            var fac: [[Facility_data]]? = []
                            for types in locations {
                                if fac == nil {
                                    fac?.removeAll()
                                } else {
                                    fac?.append(types.metadata?.facility_data ?? [])
                                }
                                
                            }
                            //  print(fac?.count)
                            
                        } else {
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
                        print("Error: \(error)")
                    }
                }
        }
        
    }
    
    func getGetAsset(forAsset iassetID: String, locationOrder: Int) {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetAsset.self ) { response1 in
                // print("Status GetAsset:\( response1.response?.statusCode ?? 0)")
                switch response1.result {
                case .success(_):
                    print("ok")
                    //                    self.coordinate = response1.value?.geoloc?.coordinates ?? []
                    //                    let pinsGas1: MyPin = MyPin( coordinate: CLLocationCoordinate2D(latitude: self.coordinate[1], longitude: self.coordinate[0] ) )
                    //                    //self.pins. = locationOrder.hashValue
                    //                    self.pins.append(pinsGas1)
                    
                case .failure(let error):
                    print("\(error)")
                }
            }
        self.hideActivity()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerStatus {
            return statusDelivery.count
            
        } else if pickerView == pickerDriver {
            return indxes.count
            
        } else if pickerView == pickerDate {
            return dateYMD.count
        }
        return 0
    }
    var car: [String] = ["Car1", "Car2", "Car3", "Car4", "Car5", "Car6", "Car7", "Car8", "Car9"]
    var arrStringDate: [String] = []
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerStatus {
            return statusDelivery[row]
            
        } else if pickerView == pickerDriver {
            return car[row]
            
        } else if pickerView == pickerDate {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            let dateString: String = formatter.string(from: dateYMD[row])
            return dateString
        }
        return ""
    }
    var dataDidFilter: [LocationElement] = []
    func getDataFiltered(date: Date, driver: Int, status: Int) -> [LocationElement] {
        var locationsByDriver: [Int: [LocationElement]] = [:]
        var tmpArr: [LocationElement] = []
        let dataOneDate: [LocationElement] = dicData[date] ?? []
        var arrCar: [String] = []
        for vehicle in dataOneDate {
            arrCar.append(vehicle.location?.locationType?.rawValue ?? "")
            if arrCar[0] == "supplier" {
                arrCar.remove(at: 0)
            } else {
            
            let indxes: [Int] = arrCar.enumerated().filter { $0.element == "supplier" }.map { $0.offset }
            print("indxes :\(indxes)")
            indxes.enumerated().forEach { idx, item in
                if Array(self.locations).count > 0 {
                    if idx == 0 {
                        tmpArr = Array(self.locations[0...indxes[0]])  // indxes[]
                    } else {
                        tmpArr = Array(self.locations[indxes[idx-1]+1...indxes[idx]])
                    }
                    //  print("\n\n\n\n\n\n\naaaaaa", tmpArr)
                    locationsByDriver[idx] = tmpArr
                }
            }
            }
        }
        
        // dataDidFilter = locationsByDriver[driver] ?? []
        var dataStatus: [LocationElement] = locationsByDriver[driver] ?? []
        
        for statusShipping in dataStatus {
            
            if statusShipping.location?.metadata?.displayData?.valueDeliveryHistory() == .waiting || statusShipping.location?.metadata?.displayData?.valueDeliveryHistory() == .failed ||
                statusShipping.location?.metadata?.displayData?.valueDeliveryHistory() == .completed {
                 dataStatus.removeAll()
                 dataStatus.append(statusShipping)
                dataDidFilter = dataStatus
            } else {
                dataDidFilter = dataStatus
            }
        }
        self.totalType()
        for i in dataStatus {
            i.locationOrder
        }
        return dataDidFilter
    }
    
    func reDrawMarkers() {
        // Duyet locations de ve lai marker tren map
        var dataDidFilter = getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver, status: selectesIdxStatus)
        print("aaaaa\(dataDidFilter) -> zzzz\(dataDidFilter.count)")
       var i = dataDidFilter.remove(at: 0)
        dataDidFilter.append(i)
        mapView.removeAnnotations(mapView.annotations)
        pinsADay.removeAll()
        
        for picker in dataDidFilter {
            if picker.latitude != nil, picker.longitude != nil {
                let carOnePin = CustomPin(title: picker.locationOrder, coordinate: CLLocationCoordinate2D(latitude: picker.latitude ?? 0, longitude: picker.longitude ?? 0 ))
                pinsADay.append(carOnePin)
            }
        }
        mapView.addAnnotations(pinsADay)
    }
    
    
    func totalType() {
        var arrtype: [[Facility_data]] = []
        var count: [Int] = []
        let type: Int = 0
        // print(filterStatus)
        for fac in dataDidFilter {
            arrtype.append(fac.metadata?.facility_data ?? [])
        }
        
        //  print(arrtype)
        
        
        //        var a =
        //        print(a)
        for i in arrtype {
            print(i)
            
        }
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerDate {
            selectedIdxDate = row
            let date: Date! = dateYMD[row]
            let valueADay: [LocationElement] = dicData[date] ?? []
            var arrCar: [String] = []
            for vehicle in valueADay {
                arrCar.append(vehicle.location?.locationType?.rawValue ?? "")
                if arrCar[0] == "supplier" {
                    arrCar.remove(at: 0)
                }
            }
            let indxes1: [Int] = arrCar.enumerated().filter { $0.element == "supplier" }.map { $0.offset }
            indxes = indxes1
            self.pickerDriver.reloadAllComponents()
            selectedIdxDriver = 0
            let locationsFiltered = self.getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver, status: selectesIdxStatus)
            self.reDrawMarkers()
            
        } else if pickerView == pickerDriver {
            selectedIdxDriver = row
            //   print{"bb"}
            //            var tmpArr: [LocationElement] = []
            ////            let locationsFilter = self.getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver)
            //            let arrCar: [String] = []
            //
            //            let indxes: [Int] = arrCar.enumerated().filter{ $0.element == "supplier" }.map{ $0.offset }
            //            print(indxes)
            //            indxes.enumerated().forEach { idx, item in
            //                if (idx == 0) {
            //                    tmpArr = Array(self.locations[0...indxes[0]])
            //                } else {
            //                    tmpArr = Array(self.locations[indxes[idx-1]+1...indxes[idx]])
            //                }
            //            }
            self.reDrawMarkers()
            
            
        } else if pickerView == pickerStatus {
            selectesIdxStatus = row
            self.reDrawMarkers()
        }
        
        
        
        
    }
    
}

extension DeliveryListController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomPin else { return nil }
        
        let identifier = "Annotation"
        var view: MyPinView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MyPinView {
            dequeuedView.annotation = annotation
            dequeuedView.image = UIImage(named: "marker")
            dequeuedView.lblView.text = "\(annotation.title)"
            view = dequeuedView
        } else {
            view = MyPinView(annotation: annotation, reuseIdentifier: identifier)
            
            view.lblView.text = "\(annotation.title)"
        }
        return view
    }
    
    
    
}
