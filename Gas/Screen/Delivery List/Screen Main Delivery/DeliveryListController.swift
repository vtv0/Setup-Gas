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
    let coordinate: CLLocationCoordinate2D
    init(title: Int, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}


//class CustomFloatingPanelLayout: FloatingPanelLayout {
//    var position: FloatingPanelPosition
//
//    var initialState: FloatingPanelState
//
//    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] = [:]
//
//
//    var initialPosition: FloatingPanelPosition {
//        return .tip
//    }
//
//    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
//        switch position {
//        case .top: return 16.0 // A top inset from safe area
//        case .half: return 216.0 // A bottom inset from the safe area
//        case .tip: return 44.0 // A bottom inset from the safe area
//        default: return nil // Or `case .hidden: return nil`
//        }
//    }
//}

class DeliveryListController: UIViewController , FloatingPanelControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    let statusDelivery = ["Not Delivery", "All"]
    var arrGetAsset: [String] = []
    
    var coordinate: [Double] = []
    var selectedIdxDate: Int = 0
    var selectedIdxDriver: Int = 0
    var selectesIdxStatus: Int = 0
    
    var arr: [Int] = []
    var pinsADay: [CustomPin] = []
    var dicData: [Date : [Location]] = [:]
    
    var indxes: [Int] = []
    var assetID: String = ""
    var locations: [LocationElement] = []
    var dataDidFilter: [LocationElement] = []
    var dateYMD: [Date] = []
    var arrStringDate: [String] = []
    var t: Int = 0
    var totalObjectSevenDate: Int = 0
    
    var customer_id: [String] = []
    var planned_date: [String] = []
    var arrivalTime_hours: [Int] = []
    var arrivalTime_minutes: [Int] = []
    var customer_name: [String] = []
    var customer_address: [String] = []
    
    var arrType: [Int] = []
    var arrNumber: [Int] = []
    
    //  var dic: [String: PropertiesDetail] = [:]
    var arrFacilityData: [[Facility_data]] = []
    
    let fpc = FloatingPanelController()
    
    var asset: [GetAsset] = []
    var arrGetAssetOneDay: [GetAsset] = []
    
    
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
        getMe()
        getLatestWorkerRouteLocationList()
        fpc.delegate = self
        
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
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 1000000.0)
        mapView.delegate = self
        mapView.setCamera(mapCamera, animated: false)
        
        
        lblType50kg.text = "\(0)"
        lblType30kg.text = "\(0)"
        lblType25kg.text = "\(0)"
        lblType20kg.text = "\(0)"
        lblOtherType.text = "\(0)"
        
        
        
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
    
    func sevenDay() {
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                dateYMD.append(date1)
            }
        }
    }
    
    func getMe() {
        let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
        let urlGetMe = "https://\(showcompanyCode).kiiapps.com/am/api/me"
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        self.showActivity()
        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetMeInfo.self) { response1 in
                switch response1.result {
                case .success(let getMeInfo):
                    UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
                    UserDefaults.standard.set(getMeInfo.id, forKey: "userId")
                case .failure(let error):
                    if response1.response?.statusCode == 401 {
                        let src = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                        self.navigationController?.pushViewController(src, animated: true)
                        break
                    } else {
                        print("Error: \(response1.response?.statusCode ?? 000000)")
                        print("Error: \(error)")
                    }
                }
            }
        self.hideActivity()
    }
    
    var arrLocationValue: [Location] = []
    
    func  getLatestWorkerRouteLocationList() {
        self.showActivity()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        for iday in dateYMD {
            let dateString: String = formatter.string(from: iday)
            let url: String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(dateString)"
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default ,headers: self.makeHeaders(token: token)).validate(statusCode: (200...299))
                .responseDecodable(of: GetLatestWorkerRouteLocationListInfo.self) { response in
                    print("\(url)::::>\( response.response?.statusCode ?? 0)")
                    
                    self.t += 1
                    
                    switch response.result {
                    case .success(_):
                        let countObject = response.value?.locations?.count
                        let locations1 = response.value?.locations ?? []
                        if countObject != 0 {
                            for itemObject in locations1 {
                                if itemObject.location?.assetID != nil {
                                    self.getGetAsset(forAsset: (itemObject.location!.assetID)!, locationOrder: itemObject.locationOrder) { iasset in
                                        //                                        if iasset != nil {
                                        //                                            self.asset.append(iasset!)
                                        //                                        }
                                        self.arrLocationValue.append(Location.init(type: .customer, elem: itemObject, asset: iasset))
                                    }
                                } else {
                                    print("No assetID -> Supplier")
                                }
                            }
                            
                            //dicData: [Date: [Location]]
                            // Location - locationElement      //  var elem: LocationElement?
                            //            - GetAsset?          //   var asset: GetAsset?
                            
                            
                          //  self.dicData[iday] = [[Location]]
                            
                            self.dicData[iday] = self.arrLocationValue
                            
                            
                            
                        } else {
                            print(response.response?.statusCode as Any)
                            print("\(url) =>> Array Empty, No Object ")
                        }
                        
                    case .failure(let error):
                        
                        print("Error: \(response.response?.statusCode ?? 000000)")
                        print("Error: \(error)")
                    }
                    
                    if self.t == self.dateYMD.count {
                        self.reDrawMarkers()
                        self.hideActivity()
                    }
                    
                }
        }
    }
    
    func getGetAsset(forAsset iassetID: String, locationOrder: Int, completion: @escaping  ((GetAsset?) -> Void)) {  // location: Location,
        
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetAsset.self ) { response1 in
                switch response1.result {
                case .success( let value):
                    
                    
                    
                    //                    let iCustomerName = response1.value?.properties?.values.customer_name ?? ""
                    //                    self.customer_name.append(iCustomerName)
                    //
                    //                    let iCustomerAddress = response1.value?.properties?.values.address ?? ""
                    //                    self.customer_address.append(iCustomerAddress)
                    
                    
                    //                    for infoCustomer in self.infoOneObject {
                    //                        print(infoCustomer)
                    //                    }
                    
                    if self.totalObjectSevenDate == self.totalObjectSevenDate {
                        self.hideActivity()
                    }
                    completion(value)
                    
                case .failure(let error):
                    print("\(error)")
                    completion(nil)
                }
            }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerStatus {
            return statusDelivery.count
            
        } else if pickerView == pickerDriver {
            if indxes.count == 0 {
                return 1
            }
            return indxes.count
            
        } else if pickerView == pickerDate {
            return dateYMD.count
        }
        return 0
    }
    var car: [String] = ["Car1", "Car2", "Car3", "Car4", "Car5", "Car6", "Car7", "Car8", "Car9"]
    
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
    
    
    func getDataFiltered(date: Date, driver: Int, status: Int) -> [LocationElement] {
        self.indxes = []
        
        var locationsByDriver: [Int: [LocationElement]] = [:]
        
        
        var dataOneDate: [Location] = dicData[date] ?? []
        //print(dataOneDate)
        
//        if dataOneDate.count > 0 && dataOneDate[0].location?.locationType! == .supplier && dataOneDate[0].locationOrder == 1 {
//            dataOneDate.remove(at: 0)
//        }
//        self.locations = dataOneDate
//
//
//
//        dataOneDate.enumerated().forEach { vehicleIdx, vehicle in
//            if (vehicle.location?.locationType?.rawValue == "supplier") {
//                indxes.append(vehicleIdx)
//            }
//
//        }
        
        indxes.enumerated().forEach { idx, item in
            if Array(self.locations).count > 0 {
                if idx == 0 && indxes[0] > 0 {
                    locationsByDriver[idx] = Array(self.locations[0...indxes[idx]])
                } else if indxes[idx-1]+1 < indxes[idx] {
                    locationsByDriver[idx] = Array(self.locations[indxes[idx-1]+1...indxes[idx]])
                }
            }
            
        }
        
        self.selectedIdxDriver = driver
        self.selectesIdxStatus = status
        self.pickerDriver.reloadAllComponents()
        
        dataDidFilter = locations
        var dataStatus: [LocationElement] = locationsByDriver[driver] ?? []
        
        for statusShipping in locationsByDriver[driver] ?? [] {
            if statusShipping.location?.metadata?.displayData?.valueDeliveryHistory() == .waiting
                && statusShipping.location?.metadata?.displayData?.valueDeliveryHistory() == .failed &&
                statusShipping.location?.metadata?.displayData?.valueDeliveryHistory() == .inprogress
            {
                dataStatus.removeAll()
                dataStatus.append(statusShipping)
                dataDidFilter = dataStatus
            } else {
                dataDidFilter = dataStatus
            }
        }
        
        self.pickerStatus.reloadAllComponents()
        self.totalType()
        
        if dataDidFilter.count != 0 {
            for infoCustomer in dataDidFilter {
                self.customer_id.append(infoCustomer.location?.comment ?? "")
                self.planned_date.append(infoCustomer.metadata?.planned_date ?? "")
                self.arrivalTime_hours.append(infoCustomer.arrivalTime?.hours ?? 0)
                self.arrivalTime_minutes.append(infoCustomer.arrivalTime?.minutes ?? 0)
                self.arrFacilityData.append(infoCustomer.metadata?.facility_data ?? [])
                
            }
            
            for iFacilityData in arrFacilityData {
                if iFacilityData.count == 1 {
                    for detailFacilityData in iFacilityData {
                        self.arrType.append(detailFacilityData.type ?? 0)
                        self.arrNumber.append(detailFacilityData.count ?? 0)
                    }
                } else if iFacilityData.count > 1 {
                    // print(iFacilityData)
                    
                    print("Add stack view, display type and count of Gas")
                }
                
                arrFacilityData.removeAll()
            }
            
            var arrAssetIdOneDay: [String] = []  // ra asset 1 ngay, 1 xe
            for iassetOneDay in dataDidFilter {
                arrAssetIdOneDay.append(iassetOneDay.location?.assetID ?? "")
                
            }
            
            //let selectInfoCustomerOneDay: [GetAsset] = dicData[date]?.asset ?? []
            // so sanh lan luot cac phan tu cua mang assetOneDay == assetID cua asset ->>>> [GetAsset]
            for iasset in asset {
                for i in 0..<arrAssetIdOneDay.count {
                    if arrAssetIdOneDay[i] == iasset.id {
                        arrGetAssetOneDay.append(iasset)
                        
                    }
                }
            }
            
            
        } else {
            print(" Khong hien thi Floating Panel ")
            fpc.removePanelFromParent(animated: true)
        }
        customFloatingPanel()
        
        return dataDidFilter
    }
    
    func customFloatingPanel() {
        guard let contentDeliveryVC = storyboard?.instantiateViewController(withIdentifier: "FloatingPanelDeliveryVC") as? FloatingPanelDeliveryVC else { return }
        if customer_id.count != 0 {
            contentDeliveryVC.data = customer_id
            
            contentDeliveryVC.customer_name = customer_name
            contentDeliveryVC.customer_address = customer_address
            
            contentDeliveryVC.arrivalTime_hours = arrivalTime_hours
            contentDeliveryVC.arrivalTime_minutes = arrivalTime_minutes
            
            contentDeliveryVC.planned_date = planned_date
            
            contentDeliveryVC.arrType = arrType
            contentDeliveryVC.arrNumber = arrNumber
            
            
            arrFacilityData.removeAll()
            //arrType.removeAll()
            // arrNumber.removeAll()
            
            customer_id.removeAll()
            customer_name.removeAll()
            customer_address.removeAll()
            arrivalTime_hours.removeAll()
            arrivalTime_minutes.removeAll()
            planned_date.removeAll()
            fpc.addPanel(toParent: self)
            fpc.set(contentViewController: contentDeliveryVC)
            // fpc.trackingScrollView(scrollView)
        }
        //        for iArrGetAssetOneDay in arrGetAssetOneDay {
        //            image.append(iArrGetAssetOneDay)
        //        }
        
    }
    
    var image: [String] = []
    
    func reDrawMarkers() {
        
        print(dicData.count)
         
        let dataDidFilter = getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver, status: selectesIdxStatus)
        mapView.removeAnnotations(mapView.annotations)
        pinsADay.removeAll()
        
        if dataDidFilter.count == 0 {
            print("_______________________________________________________________________________Không có đơn hàng nào!")
            self.showAlert(message: "Không có đơn hàng nào!")
        } else {
            
            for picker in dataDidFilter {
                if picker.latitude != nil, picker.longitude != nil {
                    let carOnePin = CustomPin(title: picker.locationOrder, coordinate: CLLocationCoordinate2D(latitude: picker.latitude ?? 0, longitude: picker.longitude ?? 0 ))
                    pinsADay.append(carOnePin)
                }
            }
            mapView.addAnnotations(pinsADay)
            let userCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
            let eyeCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
            let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 1000000.0)
            mapView.setCamera(mapCamera, animated: false)
            mapView.reloadInputViews()
            
        }
        
    }
    
    func totalType() {
        
        
        var numberType50: Int = 0
        var numberType30: Int = 0
        var numberType25: Int = 0
        var numberType20: Int = 0
        var numberTypeOther: Int = 0
        for facilityData in dataDidFilter {
            arrFacilityData.append(facilityData.metadata?.facility_data ?? [])
        }
        
        for iFacilityData in arrFacilityData {
            for detailFacilityData in iFacilityData {
                if detailFacilityData.type == 50 {
                    numberType50 = numberType50 + (detailFacilityData.count ?? 0)
                } else if detailFacilityData.type == 30 {
                    numberType30 = numberType30 + (detailFacilityData.count ?? 0)
                } else if detailFacilityData.type == 25 {
                    numberType25 = numberType25 + (detailFacilityData.count ?? 0)
                } else if detailFacilityData.type == 20 {
                    numberType20 = numberType20 + (detailFacilityData.count ?? 0)
                } else {
                    numberTypeOther = numberTypeOther + (detailFacilityData.count ?? 0)
                }
            }
        }
        lblType50kg.text = "\(numberType50)"
        lblType30kg.text = "\(numberType30)"
        lblType25kg.text = "\(numberType25)"
        lblType20kg.text = "\(numberType20)"
        lblOtherType.text = "\(numberTypeOther)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerDate {
            selectedIdxDate = row
            selectedIdxDriver = 0
            self.reDrawMarkers()
        } else if pickerView == pickerDriver {
            selectedIdxDriver = row
            self.reDrawMarkers()
        } else if pickerView == pickerStatus {
            selectesIdxStatus = row
            self.pickerStatus.reloadAllComponents()
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
            dequeuedView.lblView.text = "\(annotation.title - 1)"
            //            dequeuedView.zPriority = MKAnnotationViewZPriority.init(rawValue: 0.5)
            view = dequeuedView
        } else {
            view = MyPinView(annotation: annotation, reuseIdentifier: identifier)
            view.lblView.text = "\(annotation.title - 1)"
        }
        return view
    }
}
