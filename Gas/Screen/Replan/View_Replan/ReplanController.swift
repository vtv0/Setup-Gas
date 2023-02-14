//
//  ReplanController.swift
//  Gas
//
//  Created by Vuong The Vu on 27/09/2022.
//

import UIKit
import FloatingPanel
import Alamofire
import MapKit


protocol UncheckBtnViewCellProtocol: AnyObject {
    func uncheck(listUnCheck: [Int])
}

class ReplanController: UIViewController, FloatingPanelControllerDelegate {
    weak var delegateUncheck: UncheckBtnViewCellProtocol?
    
    var fpc = FloatingPanelController()
    var t: Int = 0
    var status: Bool = false
    let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    var dicData: [Date : [Location]] = [:]
    var dateYMD: [Date] = []
    var dataDidFilter_Replan = [Location]()
    var indxes = [Int]()
    var selectedIdxDate = 0
    var selectedIdxDriver = 0
    var arrLocationOrder = [Int]()
    var arrFacilityData: [[Facility_data]] = []
    var totalNumberOfBottle: Int = 0
    var listIndex = [Int]()
    
    var backList_Replan: [Location] = []
    var listRemove = [Location]()
    
    var listLastIndDriver = [Int]()
    var lastIndDriver1 = 0
    var lastIndDriver2 = 0
    
    var presenterReplan = Persenter_Replan()
    
    @IBOutlet weak var stackViewLarge: UIStackView!
    @IBOutlet weak var clickBtnAnimation: UIButton!
    @IBAction func clickBtnAnimation(_ sender: Any) {
        status = !status
        
        if status {
            self.viewPicker.bringSubviewToFront(self.viewAnimation)
            UIView.animate(withDuration: 0.6, delay: 0.2, options: UIView.AnimationOptions.layoutSubviews,
                           animations: {
                self.viewAnimation.isHidden = true
            },
                           completion: { aniDown in
                self.clickBtnAnimation.setImage(UIImage(named: "downAnimation"), for: .normal)
            }
            )
            
        } else {
            UIView.animate(withDuration: 0.6, delay: 0.2, options: [],
                           animations: {
                self.viewAnimation.isHidden = false
            },
                           completion:  { aniUp  in
                self.clickBtnAnimation.setImage(UIImage(named: "upAnimation"), for: .normal)
            }
            )
        }
    }
    
    @IBOutlet weak var btnClear: UIButton!
    @IBAction func btnClear(_ sender: Any) {
        
        delegateUncheck?.uncheck(listUnCheck: listIndex)
        listIndex.removeAll()
        
    }
    
    @IBOutlet weak var btnReplace: UIButton!
    @IBAction func btnReplace(_ sender: Any) {
        if !listIndex.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "CustomAlertReplanVC") as! CustomAlertReplanVC
            destinationVC.delegateClickOK = self
            
            let fomatDate = DateFormatter()
            fomatDate.dateFormat = "MM/DD"
            let dateString = fomatDate.string(from: dateYMD[0])
            
            destinationVC.dateString = dateString
            destinationVC.indxes = indxes  // so luong xe trong 1 ngay
            destinationVC.selectedIdxDate = selectedIdxDate
            destinationVC.selectedIdxDriver = selectedIdxDriver
            destinationVC.listIndex = listIndex
            
            destinationVC.dataDidFilter_Alert = dataDidFilter_Replan
            destinationVC.totalNumberOfBottle = totalNumberOfBottle
            present(destinationVC, animated: false, completion: nil)
        }
    }
    
    @IBAction func btnHideReplan(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var pickerDriver: UIPickerView!
    @IBOutlet weak var pickerDate: UIPickerView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var stackViewAnimation: UIStackView!
    
    @IBOutlet weak var lblType50kg: UILabel!
    @IBOutlet weak var lblType30kg: UILabel!
    @IBOutlet weak var lblType25kg: UILabel!
    @IBOutlet weak var lblType20kg: UILabel!
    @IBOutlet weak var lblTypeOther: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Replan"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        presenterReplan.delegateReplan = self
        
        // btnReplace.isEnabled = false
        // btnReplace.isHidden = true
        
        self.view.bringSubviewToFront(stackViewLarge)
        self.view.bringSubviewToFront(viewPicker)
        
        fpc = FloatingPanelController(delegate: self)
        fpc.layout = MyFloatingPanelLayout()
        
        pickerDriver.dataSource = self
        pickerDriver.delegate = self
        pickerDate.dataSource = self
        pickerDate.delegate = self
        
        print(dicData   )
        // getLatestWorkerRouteLocationList()
        mapView.delegate = self
        
        let userCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let eyeCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 1000000.0)
        mapView.setCamera(mapCamera, animated: false)
        //        reDrawMarkers()
    }
    
    func floatingPanel() {
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentReplanController") as? ContentReplanController else { return }
        delegateUncheck = contentVC
        contentVC.delegatePassData = self
        contentVC.dataDidFilter_Content = dataDidFilter_Replan  // da duoc loc
        
        contentVC.dateYMD = dateYMD
        contentVC.selectedIdxDate = selectedIdxDate
        contentVC.selectedIdxDriver = selectedIdxDriver
        contentVC.indxes = indxes
        fpc.contentMode = .fitToBounds
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
        
        fpc.track(scrollView: (contentVC.myTableView))
        
        
        self.view.bringSubviewToFront(btnClear)
        self.view.bringSubviewToFront(btnReplace)
    }
    
    //    func getDataFiltered(date: Date, driver: Int) -> [Location] {
    //        var locationsByDriver: [Int: [Location]] = [:]
    //        var elemLocationADay = dicData[date] ?? []
    //        // chia ra xe trong 1 ngay
    //
    //        if elemLocationADay.count > 0 && elemLocationADay[0].type == .supplier && elemLocationADay[0].elem?.locationOrder == 1 {
    //            elemLocationADay.remove(at: 0)
    //        }
    //
    //        indxes = []
    //        elemLocationADay.enumerated().forEach { vehicleIdx, vehicle in
    //            if (vehicle.type == .supplier) {
    //                indxes.append(vehicleIdx)
    //            }
    //        }
    //        indxes.enumerated().forEach { idx, item in
    //
    //            if Array(elemLocationADay).count > 0 {
    //                if idx == 0 && indxes[0] > 0 {
    //                    locationsByDriver[idx] = Array(elemLocationADay[0...indxes[idx]])
    //                } else if indxes[idx-1]+1 < indxes[idx] {
    //                    locationsByDriver[idx] = Array(elemLocationADay[indxes[idx-1]+1...indxes[idx]])
    //                }
    //            }
    //        }
    //
    //        self.selectedIdxDriver = driver
    //        self.pickerDriver.reloadAllComponents()
    //        dataDidFilter_Replan = locationsByDriver[driver] ?? []
    //        var listMoveToIsTrue: [Location] = []
    //        if dataDidFilter_Replan.isEmpty {  // hom dau khong co data
    //            // value 6 ngay con lai
    //            for idic in dicData where idic.key != dateYMD[0] {
    //                for ilocation in idic.value where ilocation.elem?.location?.metadata?.display_data?.moveToFirstDay == true {
    //                    listMoveToIsTrue.append(ilocation)
    //                }
    //            }
    //            if selectedIdxDate == 0 {
    //                dataDidFilter_Replan = listMoveToIsTrue
    //            }
    //        }
    //
    //        var checkListRemove = [Location]()  // check ngay 1 co ds Remove k
    //        if selectedIdxDate == 0 {
    //            for idic in dicData where idic.key == dateYMD[0] {
    //                for ilocation in idic.value where ilocation.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
    //                    checkListRemove.append(ilocation)
    //                }
    //            }
    //        }
    //
    //        if dataDidFilter_Replan.isEmpty && selectedIdxDate == 0 && selectedIdxDriver + 1 == indxes.count + 1 {  // driver Remove Date 1
    //            dataDidFilter_Replan = listRemove
    //        }
    //
    //        if dataDidFilter_Replan.count > 0 || checkListRemove.count > 0 {
    //            btnReplace.isHidden = false
    //            btnClear.isHidden = false
    //            totalType(EachType: 0)
    //            floatingPanel()
    //            checkListRemove.removeAll()
    //        } else {
    //            fpc.removePanelFromParent(animated: true)
    //            btnReplace.isHidden = true
    //            btnClear.isHidden = true
    //        }
    //        self.pickerDriver.reloadAllComponents()
    //        return dataDidFilter_Replan
    //    }
    
    
    enum quantityOfEachType {
        case lblType50kg
        case lblType30kg
        case lblType25kg
        case lblType20kg
        case lblTypeOther
    }
    
    func totalType(EachType: Int) {
        var numberType50: Int = 0
        var numberType30: Int = 0
        var numberType25: Int = 0
        var numberType20: Int = 0
        var numberTypeOther: Int = 0
        totalNumberOfBottle = 0
        
        arrFacilityData.removeAll()
        for facilityData in dataDidFilter_Replan {
            arrFacilityData.append(facilityData.elem?.metadata?.facility_data ?? [])
        }
        
        for iFacilityData in arrFacilityData {
            for detailFacilityData in iFacilityData {
                totalNumberOfBottle += detailFacilityData.count ?? 0
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
        lblTypeOther.text = "\(numberTypeOther)"
        
        //return .lblTypeOther
    }
    
    
    func getIndxes(date: Date, dicData: [Date: [Location]]) -> [Int] {
        //  sevenDay()
        var locationsByDriver: [Int: [Location]] = [:]
        var elemLocationADay = dicData[date] ?? []
        // chia ra xe trong 1 ngay
        
        if elemLocationADay.count > 0 && elemLocationADay[0].type == .supplier && elemLocationADay[0].elem?.locationOrder == 1 {
            elemLocationADay.remove(at: 0)
        }
        
        indxes = []
        elemLocationADay.enumerated().forEach { vehicleIdx, vehicle in
            if (vehicle.type == .supplier) {
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
        return indxes
    }
    
}

extension ReplanController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var listRemove1: [Location] = []
        for idic in dicData where idic.key == dateYMD.first {
            for iLocation in idic.value where iLocation.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                listRemove1.append(iLocation)
            }
        }
        
        if pickerView == pickerDriver {
            if !indxes.isEmpty {
                if selectedIdxDate > 0 {
                    return indxes.count
                } else if selectedIdxDate == 0 {
                    if listRemove1.isEmpty {
                        return indxes.count
                    } else {
                        return indxes.count + 1
                    }
                }
            } else {
                return 1
            }
            
        } else if pickerView == pickerDate {
            return dateYMD.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerDate {
            pickerDriver.selectRow(0, inComponent: component, animated: false)
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            let dateString: String = formatter.string(from: dateYMD[row])
            return dateString
            
        } else if pickerView == pickerDriver {
            let indxesisPresenter = getIndxes(date: dateYMD[selectedIdxDate], dicData: dicData)
            print(indxesisPresenter)
            var arrCar: [String] = []
            var listRemove1: [Location] = []
            for idic in dicData where idic.key == dateYMD.first {
                for iLocation in idic.value where iLocation.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                    listRemove1.append(iLocation)
                }
            }
            
            if !indxesisPresenter.isEmpty {  // co data
                if selectedIdxDate > 0 {  // ngay sau
                    for (ind, _) in indxesisPresenter.enumerated() {
                        arrCar.append("Car\(ind + 1)")
                    }
                    return arrCar[row]
                } else if selectedIdxDate == 0 {  // ngay dau tien
                    if listRemove.isEmpty && selectedIdxDate == 0 {
                        for (ind, _) in indxesisPresenter.enumerated() {
                            arrCar.append("Car\(ind + 1)")
                        }
                        return arrCar[row]
                    } else if selectedIdxDate == 0 {  // co ds Remove
                        if !listRemove1.isEmpty {
                            for (ind, _) in indxesisPresenter.enumerated() {
                                arrCar.append("Car\(ind + 1)")
                            }
                            arrCar.append("Remove")
                            return arrCar[row]
                        } else if listRemove1.isEmpty {
                            for (ind, _) in indxesisPresenter.enumerated() {
                                arrCar.append("Car\(ind + 1)")
                            }
                            return arrCar[row]
                        }
                    }
                }
            } else {
                return "Car1"
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerDate {
            selectedIdxDate = row
            selectedIdxDriver = 0
            
            listIndex.removeAll()
            //            presenterReplan.getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver)
            //            presenterReplan.getIndxes(date: dateYMD[row], dicData: dicData  )
            //            self.reDrawMarkers()
            
        } else if pickerView == pickerDriver {
            listIndex.removeAll()
            selectedIdxDriver = row
            //            presenterReplan.getIndxes(date: dateYMD[row], dicData: dicData  )
            //            presenterReplan.getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver)
            //            self.reDrawMarkers()
            
            
        }
    }
}

// MARK: - Draw Marker
extension ReplanController: MKMapViewDelegate {
    func showAlert(title: String? = "", message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
    
    //        if dataDidFilter_Replan.count > 0 {
    //            btnReplace.isHidden = false
    //            btnClear.isHidden = false
    //            totalType(EachType: 0)
    //            floatingPanel()
    //        } else {
    //            lblType50kg.text = "\(0)"
    //            lblType30kg.text = "\(0)"
    //            lblType25kg.text = "\(0)"
    //            lblType20kg.text = "\(0)"
    //            lblTypeOther.text = "\(0)"
    //            self.showAlert(message: "không có khách hàng nào")
    //
    //            fpc.removePanelFromParent(animated: true)
    //            btnReplace.isHidden = true
    //            btnClear.isHidden = true
    //        }
    
    
    func displayMarker(arrMoveToIsTrue: [Location], dataDidFilter_Replan: [Location], indxes: [Int]) {
        
        print(dataDidFilter_Replan)
        print(arrMoveToIsTrue)
        for picker in dataDidFilter_Replan where picker.type == .customer {
            // EXCLUDE
            if selectedIdxDriver+1 < indxes.count+1 && picker.elem?.location?.metadata?.display_data?.excludeFirstDay != true {
                if !arrMoveToIsTrue.isEmpty {
                    if selectedIdxDate == 0 && picker.elem?.location?.metadata?.display_data?.moveToFirstDay == true {
                        if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                            let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                            arrLocationOrder.append(locationOfCustomer.title)
                            mapView.addAnnotation(locationOfCustomer)
                        }
                    } else if picker.elem?.location?.metadata?.display_data?.moveToFirstDay != true {
                        if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                            let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                            arrLocationOrder.append(locationOfCustomer.title)
                            mapView.addAnnotation(locationOfCustomer)
                        }
                    }
                    
                } else if arrMoveToIsTrue.isEmpty  {
                    if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                        let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                        arrLocationOrder.append(locationOfCustomer.title)
                        mapView.addAnnotation(locationOfCustomer)
                    }
                }
                
            } else if selectedIdxDate == 0 && selectedIdxDriver+1 == indxes.count+1 && picker.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                    let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    arrLocationOrder.append(locationOfCustomer.title)
                    mapView.addAnnotation(locationOfCustomer)
                }
                
                // MoveTo FirstDay
            } else if selectedIdxDate == 0 && selectedIdxDriver+1 == indxes.count && picker.elem?.location?.metadata?.display_data?.moveToFirstDay == true {
                if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder  {
                    let locationOfCustomer = CustomPin(title: locationOrder, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    arrLocationOrder.append(locationOfCustomer.title)
                    mapView.addAnnotation(locationOfCustomer)
                }
            } else if selectedIdxDate > 0 && !arrMoveToIsTrue.isEmpty && picker.elem?.location?.metadata?.display_data?.moveToFirstDay != true {
                if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                    let locationOfCustomer = CustomPin(title: locationOrder, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    arrLocationOrder.append(locationOfCustomer.title)
                    mapView.addAnnotation(locationOfCustomer)
                }
            }
        }
    }
    
    // display marker
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomPin else { return nil }
        let identifier = "Annotation"
        var view: MyPinView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MyPinView {
            dequeuedView.annotation = annotation
            
            if  arrLocationOrder[0] == annotation.title {
                dequeuedView.lblView.text = "\(annotation.title)"
                dequeuedView.image = UIImage(named: "marker")
                dequeuedView.zPriority = MKAnnotationViewZPriority.max
            } else {
                dequeuedView.lblView.text = "\(annotation.title)"
                dequeuedView.image = UIImage(named: "marker")
                dequeuedView.zPriority = MKAnnotationViewZPriority.init(rawValue: 999 - Float(annotation.title))
            }
            dequeuedView.reloadInputViews()
            view = dequeuedView
        } else {
            view = MyPinView(annotation: annotation, reuseIdentifier: identifier)
            if arrLocationOrder[0] == annotation.title {
                view.lblView.text = "\(annotation.title)"
                view.zPriority = MKAnnotationViewZPriority.max
                view.image = UIImage(named: "marker")
            } else {
                view.lblView.text = "\(annotation.title)"
                view.zPriority = MKAnnotationViewZPriority.init(rawValue: 999 - Float(annotation.title))
                view.image = UIImage(named: "marker")
            }
        }
        return view
    }
}

extension ReplanController: PassDataDelegateProtocol {
    func check(isCustomer: Location, indexDriver: Int, indexDate: Int, indexPath: Int) {
        listIndex.append(indexPath)
    }
    
    func uncheck(isCustomer: Location, indexDriver: Int, indexDate: Int, indexPath: Int) {
        if !listIndex.isEmpty {
            listIndex.enumerated().forEach { ind, ivalue in
                if ivalue == indexPath {
                    listIndex.remove(at: ind)
                }
            }
        }
    }
}

extension ReplanController: ClickOkDelegateProtocol {
    func clickOk(listIndex: [Int]) {
        moveToFirstDay(listIndex: listIndex)
        excludeFirst(listIndex: listIndex)
        
    }
    
    func moveToFirstDay(listIndex: [Int]) {
        
        // TH date khac ngay dau
        if selectedIdxDate > 0 {
            for index in listIndex {  // boi den cac dong duoc chon
                dataDidFilter_Replan[index].elem?.location?.metadata?.display_data?.moveToFirstDay = true
            }
        }
        
        // TH date la ngay dau
        // xe cuoi, ngay 1: MoveTo true -> false
        if selectedIdxDate == 0 && selectedIdxDriver+1 == indxes.count {
            for index in listIndex {
                dataDidFilter_Replan[index].elem?.location?.metadata?.display_data?.moveToFirstDay = false
            }
            dataDidFilter_Replan = dataDidFilter_Replan.filter { location in
                return location.elem?.location?.metadata?.display_data?.moveToFirstDay != true
            }
        } else if selectedIdxDate == 0 && indxes.isEmpty {
            for index in listIndex {
                dataDidFilter_Replan[index].elem?.location?.metadata?.display_data?.moveToFirstDay = false
            }
            dataDidFilter_Replan = dataDidFilter_Replan.filter { location in
                return location.elem?.location?.metadata?.display_data?.moveToFirstDay != true
            }
        }
        //        reDrawMarkers()
    }
    
    func excludeFirst(listIndex: [Int]) {  //trong TH ngay 1, xe cuoi -> da co data duoc chuyen ve
        if selectedIdxDate > 0 {
            for index in listIndex {  // boi den cac dong duoc chon
                dataDidFilter_Replan[index].elem?.location?.metadata?.display_data?.moveToFirstDay = true
            }
        }
        
        
        var arrMoveToIsTrue = [Location]()
        for idic in dicData {  // Move To firstDay == true
            if idic.key != dateYMD.first {
                for iLocation in idic.value where iLocation.elem?.location?.metadata?.display_data?.moveToFirstDay == true {
                    arrMoveToIsTrue.append(iLocation)
                }
            }
        }
        
        if selectedIdxDate == 0 {
            if selectedIdxDriver + 1 == indxes.count {
                dataDidFilter_Replan.insert(contentsOf: arrMoveToIsTrue, at: dataDidFilter_Replan.count - 1)
                for index in listIndex {
                    for (ind, ivalue) in dataDidFilter_Replan.enumerated() {
                        if index == ind {
                            ivalue.elem?.location?.metadata?.display_data?.excludeFirstDay = true
                        }
                    }
                }
            } else if selectedIdxDriver + 1 < indxes.count {
                for index in listIndex {
                    dataDidFilter_Replan[index].elem?.location?.metadata?.display_data?.excludeFirstDay = true
                }
            }
            //            reDrawMarkers()
            self.listIndex.removeAll()
        }
        
        if selectedIdxDriver + 1 < indxes.count + 1 {
            for idic in dicData {  // Move To firstDay == true
                if idic.key == dateYMD.first {
                    for iLocation in idic.value where iLocation.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                        listRemove.append(iLocation)
                    }
                    if listRemove.count > 0 {
                        //                        reDrawMarkers()
                    }
                }
            }
        }
        
        if selectedIdxDate == 0 && selectedIdxDriver + 1 == indxes.count + 1 {
            for index in listIndex {
                // dataDidFilter_Replan[index].elem?.location?.metadata?.display_data?.excludeFirstDay = false
                for (ind, idataReplan) in dataDidFilter_Replan.enumerated() where index == ind {
                    idataReplan.elem?.location?.metadata?.display_data?.excludeFirstDay = false
                }
            }
        }
        
        for ilocation in dataDidFilter_Replan where ilocation.elem?.location?.metadata?.display_data?.excludeFirstDay != true {
            backList_Replan.append(ilocation)
        }
        if backList_Replan.count > 0 {
            //            reDrawMarkers()
        }
    }
}

//MARK: - MVP Architect Pattern
extension ReplanController: ReplanDelegateProtocol {
    
    func loadInfomationForMKMap(dataDidFilter_Replan: [Location], arrMoveToIsTrue: [Location]) {
        print("sssssssssss")
        print(dataDidFilter_Replan)
        print(arrMoveToIsTrue)
        //        displayMarker(arrMoveToIsTrue: arrMoveToIsTrue, dataDidFilter_Replan: dataDidFilter_Replan, indxes: <#[Int]#>)
    }
    
}
