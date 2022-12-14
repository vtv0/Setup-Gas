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


class CustomPin: NSObject, MKAnnotation {
    let title: Int
    let coordinate: CLLocationCoordinate2D
    init(title: Int, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 1.0, edge: .top, referenceGuide: .safeArea),
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 190.0, edge: .bottom, referenceGuide: .safeArea),
    ]
}

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
    var arrLocationOrder = [Int]()
    var dicData: [Date : [Location]] = [:]
    var indxes: [Int] = []
    var assetID: String = ""
    var dateYMD: [Date] = []
    var numberOfCallsToGetAsset: Int = 0
    var numberAssetIDOf7Date = 0
    var customer_LocationType = [String]()
    var comment: [String] = []
    var passIndexSelectedMarker = 0
    var fpc = FloatingPanelController()
    var dataDidFilter: [Location] = []
    var assetAday: [GetAsset] = []
    var locations: [Location] = []
    var arrFacilityData: [[Facility_data]] = []
    var t = 0
    
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShippingViewController") as! ShippingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        print("click Shipping tren MH chinh")
        
        //        let alert = UIAlertController(title: "L???i", message: "C?? m???t ?????a ch??? giao h??ng ???????c ch??? ?????nh", preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSetting(_ sender: Any) {
        let screenSetting = storyboard?.instantiateViewController(withIdentifier: "SettingController") as! SettingController
        //present(screenSetting, animated: true, completion: nil)
        self.navigationController?.pushViewController(screenSetting, animated: true)
    }
    @IBAction func btnReplan(_ sender: Any) {
        let screenReplan = storyboard?.instantiateViewController(withIdentifier: "ReplanController") as! ReplanController
        screenReplan.dicData = self.dicData
        screenReplan.dateYMD = dateYMD
        self.navigationController?.pushViewController(screenReplan, animated: true)
    }
    @IBAction func btnReroute(_ sender: Any) {
        let screenReroute = storyboard?.instantiateViewController(withIdentifier: "RerouteViewController") as! RerouteViewController
        self.navigationController?.pushViewController(screenReroute, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sevenDay()
//        getMe()
        
        let getMe = GetMe(url: "")
//        getMe.getMe_Block()
        
        
        fpc = FloatingPanelController(delegate: self)
        fpc.layout = MyFloatingPanelLayout()
        
        
        mapView.delegate = self
        
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
        
        mapView.setCamera(mapCamera, animated: false)
        
        //        getWorkerVehicleList()
        
        let dicData11 = GetWorkerRouteLocationList.dicData
        print(dicData11)
      
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
    
//    func getMe() {
//        self.showActivity()
//        let showcompanyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
//        let urlGetMe = "https://\(showcompanyCode).kiiapps.com/am/api/me"
//        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
//
//        AF.request(urlGetMe, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: self.makeHeaders(token: token))
//            .responseDecodable(of: GetMeInfo.self) { response1 in
//                switch response1.result {
//                case .success(let getMeInfo):
//                    UserDefaults.standard.set(getMeInfo.tenants[0].id, forKey: "tenantId")
//                    UserDefaults.standard.set(getMeInfo.id, forKey: "userId")
////                    self.getLatestWorkerRouteLocationList()
//                case .failure(let error):
//                    if response1.response?.statusCode == 401 {
//                        let src = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
//                        self.navigationController?.pushViewController(src, animated: true)
//                        break
//                    } else {
//
//                        print("Error: \(response1.response?.statusCode ?? 000000)")
//                        print("Error: \(error)")
//                    }
//                    self.hideActivity()
//                }
//            }
//    }
    
    
//    func getLatestWorkerRouteLocationList() {
//        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        
//        for iday in dateYMD {
//            let dateString: String = formatter.string(from: iday)
//            let url: String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(dateString)"
//            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default ,headers: self.makeHeaders(token: token)).validate(statusCode: (200...299))
//                .responseDecodable(of: GetLatestWorkerRouteLocationListInfo.self) { response in
//                    self.t += 1
//                    switch response.result {
//                        
//                    case .success(_):
//                        let countObject = response.value?.locations?.count
//                        let locations1: [LocationElement] = response.value?.locations ?? []
//                        if countObject != 0 {
//                            var arrLocationValue: [Location] = []
//                            for ilocationValue in locations1 where ilocationValue.location?.assetID != nil {
//                                self.numberAssetIDOf7Date += 1
//                            }
//                            for itemObject in locations1 {
//                                arrLocationValue.append(Location.init(elem: itemObject, asset: nil))
//                            }
//                            for iLocationValue in arrLocationValue {
//                                if let  assetID = iLocationValue.elem?.location?.assetID {
//                                    self.getGetAsset(forAsset: assetID) { iasset in
//                                        iLocationValue.asset = iasset
//                                    }
//                                } else { print("No assetID -> Supplier") }
//                            }
//                            self.dicData[iday] = arrLocationValue
//                        } else {
//                            print(response.response?.statusCode as Any)
//                            print("\(url) =>> Array Empty, No Object ")
//                        }
//                        
//                    case .failure(let error):
//                        print("Error: \(response.response?.statusCode ?? 000000)")
//                        print("Error: \(error)")
//                    }
//                }
//        }
//        if self.t == dateYMD.count {
//            self.numberAssetIDOf7Date += numberAssetIDOf7Date
//        }
//        
//        
//    }
    
//    func getGetAsset(forAsset iassetID: String, completion: @escaping ((GetAsset?) -> Void)) {
//        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
//        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
//        AF.request(urlGetAsset, method: .get, parameters: nil, headers: self.makeHeaders(token: token))
//            .responseDecodable(of: GetAsset.self) { response1 in
//                
//                self.numberOfCallsToGetAsset += 1
//                switch response1.result {
//                case .success( let value):
//                    completion(value)
//                case .failure(let error):
//                    print("\(error)")
//                    completion(nil)
//                }
//                
//                if self.numberAssetIDOf7Date == self.numberOfCallsToGetAsset {
//                    print(self.numberAssetIDOf7Date)
//                    print(self.numberOfCallsToGetAsset)
//                    self.hideActivity()
//                    self.reDrawMarkers()
//                }
//            }
//    }
    
    
    
    //MARK: - call API after 4 hour
    func getWorkerVehicleList() {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let url = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/worker-vehicles"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: self.makeHeaders(token: token)) .validate(statusCode: (200...299))
            .responseDecodable(of: WorkerVehicleList.self) { response in
                switch response.result {
                case .success(let value):
                    if let areaID = value.workerVehicles?.first?.areaID {
                        UserDefaults.standard.set(areaID, forKey: "AreaID")
                    }
                    self.getRouteList()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func getRouteList() {
        let areaID = UserDefaults.standard.string(forKey: "AreaID") ?? ""
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let url = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/routes?zoneID=&areaCriteria=\(areaID)&pageSize=&pageToken="
        AF.request(url, method: .get, parameters: nil, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetRouteList.self) { response1 in
                switch response1.result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
//    func getWorkerRouteLocationList() {
//        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
//        let url = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/{{tenantID}}/routes/{{routeID}}/workers/{{workerRouteID}}"
//        AF.request(url, method: .get, parameters: nil, headers: self.makeHeaders(token: token))
//            .responseDecodable(of: GetWorkerRouteLocationList.self) { response2 in
//                switch response2.result {
//                case .success(let value):
//                    print(value)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//    }
    
    
    //MARK: -
    
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
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerStatus {
            
            return statusDelivery[row]
        } else if pickerView == pickerDriver {
            var arrCar: [String] = []
            if indxes.count > 0 {
                for (ind, _) in indxes.enumerated() {
                    arrCar.append("Car\(ind + 1)")
                }
                return arrCar[row]
            }
            return "Car1"
        } else if pickerView == pickerDate {
            pickerDriver.selectRow(0, inComponent: component, animated: false)
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
            if statusShipping.elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .waiting
                && statusShipping.elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .failed &&
                statusShipping.elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .inprogress {
                
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
            lblType50kg.text = "\(0)"
            lblType30kg.text = "\(0)"
            lblType25kg.text = "\(0)"
            lblType20kg.text = "\(0)"
            lblOtherType.text = "\(0)"
            
        }
        customFloatingPanel()
        return dataDidFilter
    }
    
    func customFloatingPanel() {
        guard let contentDeliveryVC = storyboard?.instantiateViewController(withIdentifier: "FloatingPanelDeliveryVC") as? FloatingPanelDeliveryVC else { return }
        if comment.count != 0 {
            
            delegateGetIndex = contentDeliveryVC
            contentDeliveryVC.delegate1 = self
            contentDeliveryVC.delegateScrollView = self
            
            contentDeliveryVC.dataDidFilter = dataDidFilter
            contentDeliveryVC.customer_LocationType = customer_LocationType
            contentDeliveryVC.comment = comment
            
            customer_LocationType.removeAll()
            comment.removeAll()
            arrFacilityData.removeAll()
            fpc.addPanel(toParent: self)
            fpc.set(contentViewController: contentDeliveryVC)
        }
        var value: [ValuesDetail] = []
        for iArrGetAssetOneDay in assetAday where iArrGetAssetOneDay.properties?.values != nil {
            value.append(iArrGetAssetOneDay.properties!.values)
        }
        self.view.bringSubviewToFront(btnShipping)
        
    }
    
    enum quantityOfEachType: Int {
        case lblType50kg = 50
        case lblType30kg = 30
        case lblType25kg = 25
        case lblType20kg = 20
        case lblTypeOther = 0
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
                //                print(detailFacilityData)
                //                var size = quantityOfEachType.lblType50kg
                //                switch (size) {
                //                case .lblType50kg:
                //                    numberType50 = numberType50 + (detailFacilityData.count ?? 0)
                //                case .lblType30kg:
                //                    numberType30 = numberType30 + (detailFacilityData.count ?? 0)
                //                case .lblType25kg:
                //                    numberType25 = numberType25 + (detailFacilityData.count ?? 0)
                //                case .lblType20kg:
                //                    numberType20 = numberType20 + (detailFacilityData.count ?? 0)
                //                case .lblTypeOther:
                //                    numberTypeOther = numberTypeOther + (detailFacilityData.count ?? 0)
                //                }
                
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
        
        if mapView != nil {
            mapView.removeAnnotations(mapView.annotations)
        }
        dataDidFilter = getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver, status: selectesIdxStatus)
        if dataDidFilter.count == 0 {
            print("_______________________________________________________________________________Kh??ng c?? ????n h??ng n??o!")
            self.showAlert(message: "Kh??ng c?? ????n h??ng n??o!")
        } else {
            
            // dataDidFilter = dataDidFilter.sorted(by: { $0.elem?.locationOrder ?? 0 > $1.elem?.locationOrder ?? 0 })
            for picker in dataDidFilter {
                if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                    let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    arrLocationOrder.append(locationOfCustomer.title)
                    mapView.addAnnotation(locationOfCustomer)
                }
            }
            
        }
        passIndexSelectedMarker = 0
    }
    
}


extension DeliveryListController: MKMapViewDelegate, ShowIndexPageDelegateProtocol {
    
    func passIndexPVC(currentIndexPageVC: Int) {
        passIndexSelectedMarker = currentIndexPageVC
        // remove anotations
        let allAnmotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnmotations)
        // draw marker
        if dataDidFilter.count == 0 {
            print("_______________________________________________________________________________Kh??ng c?? ????n h??ng n??o!")
        } else {
            for picker in dataDidFilter {
                if let lat = picker.elem?.latitude,
                   let long = picker.elem?.longitude,
                   let locationOrder = picker.elem?.locationOrder {
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
                dequeuedView.zPriority = MKAnnotationViewZPriority.init(rawValue: 999 - Float(annotation.title))
                
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
                view.zPriority = MKAnnotationViewZPriority.init(rawValue: 999 - Float(annotation.title))
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
            arrLocationOrder.enumerated().forEach { index, value in
                if clickIndexMarker == value {
                    passIndexSelectedMarker = index
                }
            }
            
            // delegate Protocol
            delegateGetIndex?.getIndexMarker(indexDidSelected: passIndexSelectedMarker)
            
            // remove marker
            mapView.removeAnnotations(mapView.annotations)
            if dataDidFilter.count == 0 {
                self.showAlert(message: "Kh??ng c?? ????n h??ng n??o!")
                
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


extension DeliveryListController: PassScrollView {
    func passScrollView(scrollView: UIScrollView) {
        fpc.track(scrollView: scrollView)
    }
}
