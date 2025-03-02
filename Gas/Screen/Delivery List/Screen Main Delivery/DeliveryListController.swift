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
//    let weightEachOrder: [Int: Int]
        let topIdOrder: Int
    init(title: Int, coordinate: CLLocationCoordinate2D, topIdOrder: Int) { //  weightEachOrder: [Int: [Facility_data]?]?)
        self.title = title
        self.coordinate = coordinate
//        self.weightEachOrder = weightEachOrder
                self.topIdOrder = topIdOrder
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

class DeliveryListController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, FloatingPanelControllerDelegate {
    
    weak var delegateGetIndex: GetIndexMarkerDelegateProtocol?
    
    var getiAsset: GetAsset = GetAsset(assetModelID: 0)
    let arrGetAsset: [GetAsset] = []
    var arrAssetID: [String] = []
    
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    let statusDelivery = ["Not Delivery", "All"]
    var coordinate: [Double] = []
    var selectedIdxDate: Int = 0
    var selectedIdxDriver: Int = 0
    var selectesIdxStatus: Int = 0
    var arrLocationOrder = [Int]()
    var dicData: [Date : [Location]] = [:]
    var indxes: [Int] = []
    var dateYMD: [Date] = []
    var customer_LocationType = [String]()
    var comment: [String] = []
    var passIndexSelectedMarker = 0
    var fpc = FloatingPanelController()
    var dataDidFilter: [Location] = []
    var assetAday: [GetAsset] = []
    var locations: [Location] = []
    var arrFacilityData: [[Facility_data]] = []
    var topLargeOrder: [Int] = []
    static var dataInfoOneCustomer: Location = Location(elem: LocationElement(locationOrder: 0), asset: GetAsset(assetModelID: 0))
    
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
        
        let shipingVC = storyboard?.instantiateViewController(withIdentifier: "ShippingViewController") as! ShippingViewController
        self.navigationController?.pushViewController(shipingVC, animated: true)
        
        shipingVC.dataInfoOneCustomer = DeliveryListController.dataInfoOneCustomer
        //  shipingVC.lblCustomerName.text = txtName
        print("click Shipping tren MH chinh")
        
        //        let alert = UIAlertController(title: "Lỗi", message: "Có một địa chỉ giao hàng được chỉ định", preferredStyle: .alert)
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
        //        screenReplan.dateYMD = dateYMD
        self.navigationController?.pushViewController(screenReplan, animated: true)
    }
    @IBAction func btnReroute(_ sender: Any) {
        let screenReroute = storyboard?.instantiateViewController(withIdentifier: "RerouteViewController") as! RerouteViewController
        self.navigationController?.pushViewController(screenReroute, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sevenDay()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        //MARK: - Use Block
        showActivity()
        
        //  callAPI_Block_Delivery()
        
        //MARK: - Use ASYNC AWAIT
        Task {
            await callApi_Async_Await_Deli()
        }
        
        let userCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let eyeCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 1000000.0)
        mapView.setCamera(mapCamera, animated: false)
    }
    
    
    func callApi_Async_Await_Deli() async {
        do {
            let responseGetMe = try await GetMe_Async_Await().getMe_Async_Await(companyCode: companyCode)
            print(responseGetMe)
            do {
                let dicDataResponse = try await GetWorkerRouteLocationList_Async_Await().loadDic(dates: dateYMD)   //.getWorkerRouteLocationList_Async_Await()
                dicData = dicDataResponse
            } catch {
                if let err = error as? GetWorkerRouteLocationList_Async_Await.AFError {
                    if err == .remain {
                        showAlert(message: "Có lỗi xảy ra")
                        hideActivity()
                    } else if err == .notDelivery {  // 204
                        showAlert(message: "Không giao hàng hôm nay")
                        hideActivity()
                    } else if err == .tokenOutOfDate {  // 401
                        let mhLogin = self.storyboard?.instantiateViewController(identifier:  "LoginViewController") as! ViewController
                        self.navigationController?.pushViewController(mhLogin, animated: true)
                        hideActivity()
                    } else {  // 404
                        hideActivity()
                        showAlert(message: "Lỗi API sau 16h (404)")
                        
                    }
                }
            }
            
        } catch {
            if let err = error as? GetMe_Async_Await.AFError {
                if err == .tokenOutOfDate {
                    hideActivity()
                    let scr = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                    self.navigationController?.pushViewController(scr, animated: true)
                    showAlert(message: "Token đã hết hạn -> Login lại")
                } else if err == .remain {
                    hideActivity()
                    showAlert(message: "Có lỗi xảy ra")
                }
            }
        }
        
        fpc = FloatingPanelController(delegate: self)
        fpc.layout = MyFloatingPanelLayout()
        
        mapView.delegate = self
        
        pickerStatus.dataSource = self
        pickerStatus.delegate = self
        
        pickerDriver.dataSource = self
        pickerDriver.delegate = self
        
        pickerDate.dataSource = self
        pickerDate.delegate = self
        
        // ghim location Screen
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let userCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let eyeCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 1000000.0)
        
        mapView.setCamera(mapCamera, animated: false)
        
        self.hideActivity()
        self.reDrawMarkers()
        
        
    }
    
    func passScreenLogin() {
        let scr = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
        self.navigationController?.pushViewController(scr, animated: true)
    }
    
    func getAsset_Async_Await(iassetID: String) async -> GetAsset {
        let token1 = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        let getAsset = AF.request(urlGetAsset, method: .get, parameters: nil, headers: self.makeHeaders(token: token1)).serializingDecodable(GetAsset.self)
        let assetResponse = await getAsset.response
        
        switch assetResponse.result {
        case .success(let iasset):
            print(iasset)
            getiAsset = iasset
            
        case .failure(let error):
            print(error)
            if assetResponse.response?.statusCode == 401 {
                let scr = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                navigationController?.pushViewController(scr, animated: false)
                hideActivity()
            } else if assetResponse.response?.statusCode == 500 {
                showAlert(message: "Có lỗi xảy ra")
            }
        }
        return getiAsset
    }
    
    func callApiParallel(arrLocationValue: [Location]) async -> [GetAsset] {
        await withTaskGroup(
            of: (GetAsset).self,
            returning: [GetAsset].self) { [self] group in
                
                for iLocationValue in arrLocationValue {
                    if let assetID = iLocationValue.elem?.location?.assetID {
                        group.addTask { await ( self.getAsset_Async_Await(iassetID: assetID)) }
                        
                        var arriasset: [GetAsset] = []
                        //                        arriasset.append()
                        for await result in group {
                            arriasset.append(result)
                        }
                        return arriasset // Biểu thức là 'async' nhưng không được đánh dấu bằng 'await'
                        //   }
                    } else { print("No assetID -> Supplier") }
                }
                return self.arrGetAsset
            }
    }
    
    func callAPI_Block_Delivery() {
        let dispatchGroup = DispatchGroup()
        
        GetMe_Block().getMe_Block(commpanyCode: "", acccessToken: "") { [self] dataID, detailError  in
            if !dataID.isEmpty {
                
                GetWorkerRouteLocationList_Block().getWorkerRouteLocationList_Block(tenantId: 0, userId: 0) { [self] dic, err1  in
                    if !dic.isEmpty {
                        GetAsset_Block().getGetAsset_Block(forAsset: "") { [self] info, err2  in
                            
                            dicData = dic
                            fpc = FloatingPanelController(delegate: self)
                            fpc.layout = MyFloatingPanelLayout()
                            mapView.delegate = self
                            
                            pickerStatus.dataSource = self
                            pickerStatus.delegate = self
                            
                            pickerDriver.dataSource = self
                            pickerDriver.delegate = self
                            
                            pickerDate.dataSource = self
                            pickerDate.delegate = self
                            
                            dispatchGroup.notify(queue: .main) {
                                self.hideActivity()
                                self.reDrawMarkers()
                            }
                        }
                    } else {
                        let err1 = err1
                        switch err1 {
                        case .ok: break
                        case .tokenOutOfDate:
                            let scr = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                            self.navigationController?.pushViewController(scr, animated: false)
                            hideActivity()
                            
                        case .some(.remain): break  // 500
                            //                            showAlert(message: "Có lỗi xảy ra")
                            //                            hideActivity()
                            
                        case .some(.wrong):  // 404
                            showAlert(message: "Có lỗi xảy ra")
                            hideActivity()
                        case .none:
                            break
                        }
                    }
                }
            }
            
            let err = detailError
            switch err {
            case .ok:
                break
            case .tokenOutOfDate:
                // Login
                if let scr = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? ViewController {
                    navigationController?.pushViewController(scr, animated: false)
                    hideActivity()
                }
            case .wrongPassword:
                break
            case .remain:
                showAlert(message: "Có lỗi xảy ra")
                hideActivity()
            }
        }
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let userCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let eyeCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 1000000.0)
        mapView.setCamera(mapCamera, animated: false)
    }
    
    //    func fetchAPI<T: Decodable>(url: URL) async throws -> T {
    //        let data = try await URLSession.shared.data(url: url)
    //        let decodeData = try JSONDecoder().decode(T.self, from: data)
    //        return decodeData
    //    }
    
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
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor)?.removeTimeStamp {
                dateYMD.append(date1)
            }
        }
    }
    
    
    //MARK: - call API after 4 hour
    //    func getWorkerVehicleList() {
    //        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    //        let url = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/worker-vehicles"
    //        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: self.makeHeaders(token: token)) .validate(statusCode: (200...299))
    //            .responseDecodable(of: WorkerVehicleList.self) { response in
    //                switch response.result {
    //                case .success(let value):
    //                    if let areaID = value.workerVehicles?.first?.areaID {
    //                        UserDefaults.standard.set(areaID, forKey: "AreaID")
    //                    }
    //                    self.getRouteList()
    //                case .failure(let error):
    //                    print(error)
    //                }
    //            }
    //    }
    //
    //    func getRouteList() {
    //        let areaID = UserDefaults.standard.string(forKey: "AreaID") ?? ""
    //        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    //        let url = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/routes?zoneID=&areaCriteria=\(areaID)&pageSize=&pageToken="
    //        AF.request(url, method: .get, parameters: nil, headers: self.makeHeaders(token: token))
    //            .responseDecodable(of: GetRouteList.self) { response1 in
    //                switch response1.result {
    //                case .success(let value):
    //                    print(value)
    //                case .failure(let error):
    //                    print(error)
    //                }
    //            }
    //    }
    
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
            return indxes.count+1
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
                arrCar.append("AllCars")
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
        if driver+1 < indxes.count+1 {
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
        } else if driver+1 == indxes.count+1 {
            var dataStatus: [Location] = dataOneDate
            for statusShipping in dataOneDate {
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
            guard let scrollview = contentDeliveryVC.pageController.viewControllers?.first as? PageDetailVC else { return }
            fpc.track(scrollView: scrollview.viewContainerScrollview)
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
            print("_______________________________________________________________________________Không có đơn hàng nào!")
            self.showAlert(message: "Không có đơn hàng nào!")
        } else {
            
            // dataDidFilter = dataDidFilter.sorted(by: { $0.elem?.locationOrder ?? 0 > $1.elem?.locationOrder ?? 0 })
            for picker in dataDidFilter {
                if let lat = picker.elem?.latitude,
                   let long = picker.elem?.longitude,
                   let locationOrder = picker.elem?.locationOrder {
                    let locationOfCustomer = CustomPin(title: locationOrder, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), topIdOrder: bigestOrder(locations: dataDidFilter))
                    print(locationOfCustomer.title)
                    arrLocationOrder.append(locationOfCustomer.title)
                    mapView.addAnnotation(locationOfCustomer)
                }
            }
            print(arrLocationOrder)
            let _ = bigestOrder(locations: dataDidFilter)
        }
        

        passIndexSelectedMarker = 0
        
        
    }
    func bigestOrder(locations: [Location]) -> Int {
        var idBigestOrder: Int = 0
        let dicBigOrder: [Int:Int] = [:]
        var weightEachOrderCustom: [Int: [[Facility_data]]?]? = [:]
        var weightEachOrder: [Int: [Facility_data]?]? = [:]
        
        var filterOK: [Int: Int] = [:]
        var arrWeight: [Int] = []
        
        for i in locations {
//            weightEachOrder?.updateValue(i.elem?.locationOrder, forKey: i.elem?.metadata?.facility_data)
            weightEachOrder?.updateValue(i.elem?.metadata?.facility_data, forKey: i.elem?.locationOrder ?? 1)
        }
        weightEachOrderCustom?.removeAll()
        // loai bo cac dic co value  la rong
        let weightEachOrderFilter = weightEachOrder?.compactMapValues({ $0 }) // bo xe cuoi cung
        
        weightEachOrderFilter?.forEach({ ikey, ivalue  in
            // tao mang [loai,so luong]
            var arr: [Facility_data] = []
            arr.append(contentsOf: ivalue)
            weightEachOrderCustom?.updateValue([arr], forKey: ikey)
        })
        
        weightEachOrderCustom?.forEach({ ikeyCustom, ivalueCustom in
            ivalueCustom?.forEach({ iDetailValue in
                if iDetailValue.count == 1 {
                    let weight = (iDetailValue[0].count ?? 1) * (iDetailValue[0].type ?? 1)
                    arrWeight.append(weight)
                    filterOK.updateValue(weight, forKey: ikeyCustom)
                } else if iDetailValue.count > 1 {
                    let weight = (iDetailValue[0].count ?? 1) * (iDetailValue[0].type ?? 1) + ( iDetailValue[1].count ?? 1) * (iDetailValue[1].type ?? 1)
                    arrWeight.append(weight)
                    filterOK.updateValue(weight, forKey: ikeyCustom)
                }
            })
            
        })
        
        // sap xep gia tri lon -> be (top 5)
        var dicFilterValue = filterOK.sorted { $0.1 > $1.1 }.prefix(5)
        print(dicFilterValue)
        // xep ngay
        var sortedFilterValue = Array(filterOK.keys).sorted(by: { filterOK[$0]! > filterOK[$1]! })
        print("\(sortedFilterValue):\(sortedFilterValue.count)")
        for (ind, ivalue) in sortedFilterValue.enumerated() {
            idBigestOrder = ivalue
        }
        
        print(dicBigOrder)
        print(idBigestOrder)
        return idBigestOrder
    }
}


extension DeliveryListController: MKMapViewDelegate, ShowIndexPageDelegateProtocol {
    func passIndexPVC(currentIndexPageVC: Int) {
        passIndexSelectedMarker = currentIndexPageVC
        // dataInfoOneCustomer = dataDidFilter[currentIndexPageVC]
        // remove anotations
        let allAnmotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnmotations)
        // draw marker
        if dataDidFilter.count == 0 {
            print("_____________________________________________________________Không có đơn hàng nào!")
        } else {
            for picker in dataDidFilter {
                if let lat = picker.elem?.latitude,
                   let long = picker.elem?.longitude,
                   let locationOrder = picker.elem?.locationOrder {
                    let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), topIdOrder: bigestOrder(locations: dataDidFilter))
                    mapView.addAnnotation(locationOfCustomer)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomPin else { return nil }
        let identifier = "Annotation"
        var view: MyPinView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MyPinView {
            dequeuedView.annotation = annotation
            if  arrLocationOrder[passIndexSelectedMarker] == annotation.title {
                dequeuedView.lblView.text = "\(annotation.title - 1)"
                dequeuedView.image = UIImage(named: "marker_yellow")
                dequeuedView.zPriority = MKAnnotationViewZPriority.max
            } else {
              
                if  annotation.title == annotation.topIdOrder - 1 {
                    dequeuedView.lblView.text = "\(annotation.title - 1)"
                    dequeuedView.image = UIImage(named: "marker_blue_bigger")
                    dequeuedView.zPriority = MKAnnotationViewZPriority.max  // init(rawValue: 999 - Float(annotation.title))
                } else {
                    dequeuedView.lblView.text = "\(annotation.title - 1)"
                    dequeuedView.image = UIImage(named: "marker")
                    dequeuedView.zPriority = MKAnnotationViewZPriority.init(rawValue: 999 - Float(annotation.title))
                }
                
            }
            dequeuedView.reloadInputViews()
            view = dequeuedView
        } else {
            view = MyPinView(annotation: annotation, reuseIdentifier: identifier)
            var arrTitle = [Int]()
            arrTitle.append(annotation.title)
            var arrtopIdOrder: [Int] = []
            
            print("\(arrtopIdOrder)")
            print("\(arrtopIdOrder.sorted().first)")
            print("\(arrTitle))")
            arrtopIdOrder.append(annotation.topIdOrder)
            if arrLocationOrder[0] == arrTitle.sorted().first {
                view.lblView.text = "\(annotation.title - 1)"
                view.zPriority = MKAnnotationViewZPriority.max
                view.image = UIImage(named: "marker_yellow")
            } else {
               
                if annotation.title == arrtopIdOrder.sorted().first {
                    view.lblView.text = "\(annotation.title - 1)"
                    view.zPriority = MKAnnotationViewZPriority.max//init(rawValue: 999 - Float(annotation.title))
                    view.image = UIImage(named: "marker_blue_bigger")
                    
                    //                        view.imageView.frame.size.width = CGFloat(80)
                    //                        view.imageView.frame.size.height = CGFloat(80)
                    //                        view.lblView = UILabel(frame: CGRect(x: 0, y: 0, width: (view.imageView.frame.size.width - 1), height: (view.imageView.frame.size.height - 1 )  ))
                    //                        view.lblView.backgroundColor = .red
                    //                        view.lblView.textAlignment = .center
                    //                        view.lblView.layer.cornerRadius = view.lblView.frame.size.width / 2
                    //                        view.lblView.layer.masksToBounds = true
                } else {
                    view.lblView.text = "\(annotation.title - 1)"
                    view.zPriority = MKAnnotationViewZPriority.init(rawValue: 999 - Float(annotation.title))
                    view.image = UIImage(named: "marker")
                }
                
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
                //                self.showAlert(message: "Không có đơn hàng nào!")
            } else {
                for picker in dataDidFilter {
                    if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                        let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), topIdOrder: bigestOrder(locations: dataDidFilter))
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
        fpc.surfaceView.bringSubviewToFront(scrollView)
    }
}


extension DeliveryListController: PassInfoCustomer {
    func passInfoCustomer(infoCustomer: Location) {
        DeliveryListController.dataInfoOneCustomer = infoCustomer
    }
}
