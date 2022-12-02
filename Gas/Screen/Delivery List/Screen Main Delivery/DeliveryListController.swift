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

protocol GetIndexMarkerDelegateProtocol: AnyObject {
    func getIndexMarker(indexDidSelected: Int)
}

class DeliveryListController: UIViewController , FloatingPanelControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegateGetIndex: GetIndexMarkerDelegateProtocol?
    
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
    var arrLocationOrder = [Int]()
    var dicData: [Date : [Location]] = [:]
    var indxes: [Int] = []
    var assetID: String = ""
    var dateYMD: [Date] = []
    var arrStringDate: [String] = []
    var t: Int = 0
    
    
    var customer_LocationType = [String]()
    
    var comment: [String] = []
    
    var passIndexSelectedMarker = 0
    var currentIndex = 0
    let fpc = FloatingPanelController()
    
    var dataDidFilter: [Location] = []
    var assetAday: [GetAsset] = []
    var locations: [Location] = []
    var scrollView: UIScrollView!
    var arrFacilityData: [[Facility_data]] = []
    
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
        fpc.delegate = self
        
        pickerStatus.dataSource = self
        pickerStatus.delegate = self
        
        pickerDriver.dataSource = self
        pickerDriver.delegate = self
        
        pickerDate.dataSource = self
        pickerDate.delegate = self
        
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
        self.showActivity()
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
                    self.getLatestWorkerRouteLocationList()
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
    }
    
    func  getLatestWorkerRouteLocationList() {
        // self.showActivity()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        for iday in dateYMD {
            let dateString: String = formatter.string(from: iday)
            let url: String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(dateString)"
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default ,headers: self.makeHeaders(token: token)).validate(statusCode: (200...299))
                .responseDecodable(of: GetLatestWorkerRouteLocationListInfo.self) { response in
                    self.t += 1
                    switch response.result {
                    case .success(_):
                        let countObject = response.value?.locations?.count
                        let locations1: [LocationElement] = response.value?.locations ?? []
                        if countObject != 0 {
                            var arrLocationValue: [Location] = []
                            for itemObject in locations1 {
                                arrLocationValue.append(Location.init(elem: itemObject, asset: nil))
                            }
                            for iLocationValue in arrLocationValue {
                                if let  assetID = iLocationValue.elem?.location?.assetID {
                                    self.getGetAsset(forAsset: assetID) { iasset in
                                        iLocationValue.asset = iasset
                                    }
                                } else {
                                    print("No assetID -> Supplier")
                                }
                            }
                            self.dicData[iday] = arrLocationValue
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
    
    func getGetAsset(forAsset iassetID: String, completion: @escaping  ((GetAsset?) -> Void)) {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetAsset.self ) { response1 in
                switch response1.result {
                case .success( let value):
                    
                    self.hideActivity()
                    
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
    
    func getDataFiltered(date: Date, driver: Int, status: Int) -> [Location] {
        self.indxes = []
        var locationsByDriver: [Int: [Location]] = [:]
        var elemLocationADay = [Location]()
        var dataOneDate: [Location] = dicData[date] ?? []
        if dataOneDate.count > 0 && dataOneDate[0].type == .supplier && dataOneDate[0].elem?.locationOrder == 1 {
            dataOneDate.remove(at: 0)
        }
        dataOneDate.forEach() { idataADay in
            elemLocationADay.append(idataADay)
        }
        locations = elemLocationADay
        elemLocationADay.enumerated().forEach { vehicleIdx, vehicle in
            if (vehicle.elem?.location?.locationType?.rawValue == "supplier") {
                indxes.append(vehicleIdx)
            }
        }
        indxes.enumerated().forEach { idx, item in
            if Array(elemLocationADay).count > 0 {
                if idx == 0 && indxes[0] > 0 {
                    locationsByDriver[idx] = Array(elemLocationADay[0...indxes[idx]])
                } else if indxes[idx-1]+1 < indxes[idx] {
                    locationsByDriver[idx] = Array(elemLocationADay[indxes[idx-1]+1...indxes[idx]])
                }
            }
        }
        self.selectedIdxDriver = driver
        self.selectesIdxStatus = status
        self.pickerDriver.reloadAllComponents()
        var dataStatus: [Location] = locationsByDriver[driver] ?? []
        for statusShipping in dataStatus {
            if statusShipping.elem?.location?.metadata?.displayData?.valueDeliveryHistory() == .waiting
                && statusShipping.elem?.location?.metadata?.displayData?.valueDeliveryHistory() == .failed &&
                statusShipping.elem?.location?.metadata?.displayData?.valueDeliveryHistory() == .inprogress
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
        if dataDidFilter.count > 0 {
            for infoCustomer in dataDidFilter {
                self.comment.append(infoCustomer.elem?.location?.comment ?? "")
            }
        } else {
            
            // btnShipping.removeFromSuperview()
            fpc.removePanelFromParent(animated: true)
        }
        
        customFloatingPanel()
        
        return dataDidFilter
    }
    
    func customFloatingPanel() {
        guard let contentDeliveryVC = storyboard?.instantiateViewController(withIdentifier: "FloatingPanelDeliveryVC") as? FloatingPanelDeliveryVC else { return }
        if comment.count != 0 {
            
            delegateGetIndex = contentDeliveryVC
            contentDeliveryVC.delegate1 = self
            
            contentDeliveryVC.dataDidFilter = dataDidFilter
            contentDeliveryVC.customer_LocationType = customer_LocationType
            contentDeliveryVC.comment = comment
            
            
            contentDeliveryVC.currentIndex = passIndexSelectedMarker
            
            
            // contentDeliveryVC.passIndexSelectedMarker = passIndexSelectedMarker
            
            customer_LocationType.removeAll()
            comment.removeAll()
            arrFacilityData.removeAll()
            fpc.addPanel(toParent: self)
            fpc.set(contentViewController: contentDeliveryVC)
            // fpc.trackingScrollView
        }
        var value: [ValuesDetail] = []
        for iArrGetAssetOneDay in assetAday where iArrGetAssetOneDay.properties?.values != nil {
            value.append(iArrGetAssetOneDay.properties!.values)
        }
        self.view.bringSubviewToFront(btnShipping)
    }
    
    func totalType() {
        var numberType50: Int = 0
        var numberType30: Int = 0
        var numberType25: Int = 0
        var numberType20: Int = 0
        var numberTypeOther: Int = 0
        for facilityData in dataDidFilter {
            arrFacilityData.append(facilityData.elem?.metadata?.facility_data ?? [])
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
            self.reDrawMarkers()
        }
    }
    
    func reDrawMarkers() {
        dataDidFilter.removeAll()
        arrLocationOrder.removeAll()
        arrCoordinate.removeAll()
        if mapView != nil {
            mapView.removeAnnotations(mapView.annotations)
        }
        dataDidFilter = getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver, status: selectesIdxStatus)
        if dataDidFilter.count == 0 {
            print("_______________________________________________________________________________Không có đơn hàng nào!")
            self.showAlert(message: "Không có đơn hàng nào!")
        } else {
            
            //            dataDidFilter = dataDidFilter.sorted(by: { $0.elem?.locationOrder ?? 0 > $1.elem?.locationOrder ?? 0 })
            for picker in dataDidFilter {
                if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                    let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    arrLocationOrder.append(locationOfCustomer.title)
                    //mapView.addAnnotation(locationOfCustomer)
                    arrCoordinate.append(locationOfCustomer)
                }
            }
            
            let arrCoordinateDidSort = arrCoordinate.sorted(by: { $0.title > $1.title } )
            
            mapView.addAnnotations(arrCoordinateDidSort)
        }
        passIndexSelectedMarker = 0
    }
    var arrCoordinate = [CustomPin]()
}


extension DeliveryListController: MKMapViewDelegate, ShowIndexPageDelegateProtocol {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is FloatingPanelDeliveryVC
        {
            let vc = segue.destination as? FloatingPanelDeliveryVC
            vc?.currentIndex = passIndexSelectedMarker
        }
    }
    
    func passIndexPVC(currentIndexPageVC: Int) {
        passIndexSelectedMarker = currentIndexPageVC
        // remove anotations
        let allAnmotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnmotations)
        // draw marker
        if dataDidFilter.count == 0 {
            print("_______________________________________________________________________________Không có đơn hàng nào!")
        } else {
            for picker in dataDidFilter {
                if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                    let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    mapView.addAnnotation(locationOfCustomer)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomPin else { return nil }
        
        print("LocationOrder: \(annotation.title)")
        
        let identifier = "Annotation"
        var view: MyPinView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MyPinView {
            dequeuedView.annotation = annotation
            
            
            if  arrLocationOrder[passIndexSelectedMarker] == annotation.title {
                dequeuedView.lblView.text = "\(annotation.title - 1)"
                dequeuedView.image = UIImage(named: "marker_yellow")
                dequeuedView.zPriority = MKAnnotationViewZPriority.max
            } else {
                dequeuedView.lblView.text = "\(annotation.title - 1)"
                dequeuedView.image = UIImage(named: "marker")
                //                dequeuedView.layer.zPosition = CGFloat( -annotation.title)
                //                dequeuedView.backgroundColor = .gray
                //                dequeuedView.lblView.layer.zPosition = CGFloat( -annotation.title)
                dequeuedView.zPriority = MKAnnotationViewZPriority.init(rawValue: -Float(annotation.title))
            }
            dequeuedView.reloadInputViews()
            view = dequeuedView
            
        } else {
            
            view = MyPinView(annotation: annotation, reuseIdentifier: identifier)
            var arrTitle = [Int]()
            arrTitle.append(annotation.title)
            
            if arrLocationOrder[0] == arrTitle.sorted().first {
                
                view.lblView.text = "\(annotation.title - 1)"
                view.zPriority = MKAnnotationViewZPriority.max
                view.image = UIImage(named: "marker_yellow")
            } else {
                view.lblView.text = "\(annotation.title - 1)"
                view.zPriority = MKAnnotationViewZPriority.init(rawValue: -Float(annotation.title))
                //                view.imageView.layer.zPosition = CGFloat(exactly: -Float(annotation.title)) ?? 0
                
                view.imageView.backgroundColor = .systemGreen
                view.image = UIImage(named: "marker")
            }
        }
        view.reloadInputViews()
        mapView.reloadInputViews()
        return view
    }
    
    // selected marker on MKMapView
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let anno = view.annotation as? CustomPin {
            //lay index trong mang
            let clickIndexMarker = anno.title
            arrLocationOrder.enumerated().forEach {  index, value in
                if clickIndexMarker == value {
                    passIndexSelectedMarker = index
                }
            }
            
            // delegate Protocol
            delegateGetIndex?.getIndexMarker(indexDidSelected: passIndexSelectedMarker)
            
            // remove marker
            mapView.removeAnnotations(mapView.annotations)
            
            if dataDidFilter.count == 0 {
                self.showAlert(message: "Không có đơn hàng nào!")
            } else {
                for picker in dataDidFilter {
                    if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                        let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                        mapView.addAnnotation(locationOfCustomer)
                    }
                }
            }
            
        }
    }
    
    
}





