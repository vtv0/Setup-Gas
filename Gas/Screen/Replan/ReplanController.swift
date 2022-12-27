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



class ReplanController: UIViewController, FloatingPanelControllerDelegate {
    
    let viewBtnAnimation = UIButton()
    let fpc = FloatingPanelController()
    var t: Int = 0
    
    var status: Bool = false
    let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    var dicData: [Date : [Location]] = [:]
    var dateYMD: [Date] = []
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    var dataDidFilter_Replan = [Location]()
    var indxes = [Int]()
    var selectedIdxDate = 0
    var selectedIdxDriver = 0
    var arrLocationOrder = [Int]()
    var arrFacilityData: [[Facility_data]] = []
    
    var arrAssetID = [String]()
    
    
    var listIndex = [Int]()
    var dicExcludeOfDriver: [Int: [Location]] = [:]
    
    var selectedRows1: [Int] = []
    var storageListExclude: [Location] = []
    var listMoveToIsTrue: [Location] = []
    
    var backList_Replan: [Location] = []
    var listRemove = [Location]()
    
    
    @IBOutlet weak var btnClear: UIButton!
    @IBAction func btnClear(_ sender: Any) {
        listIndex.removeAll()
        
        let view = fpc.contentViewController as! ContentReplanController
        view.myTableView.reloadData()
    }
    
    @IBOutlet weak var btnReplace: UIButton!
    @IBAction func btnReplace(_ sender: Any) {
        if !listIndex.isEmpty {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "CustomAlertReplanVC") as! CustomAlertReplanVC
            destinationVC.delegateClickOK = self
            
            destinationVC.indxes = indxes  // so luong xe trong 1 ngay
            destinationVC.selectedIdxDate = selectedIdxDate
            destinationVC.selectedIdxDriver = selectedIdxDriver
            destinationVC.listIndex = listIndex
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
        //btnReplace.isEnabled = false
        // btnReplace.isHidden = true
        
        fpc.delegate = self
        
        pickerDriver.dataSource = self
        pickerDriver.delegate = self
        pickerDate.dataSource = self
        pickerDate.delegate = self
        
        //     navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // getLatestWorkerRouteLocationList()
        mapView.delegate = self
        
        let userCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let eyeCoordinate = CLLocationCoordinate2D(latitude: 35.73774428640241, longitude: 139.6194163709879)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 1000000.0)
        mapView.setCamera(mapCamera, animated: false)
        reDrawMarkers()
    }
    
    func floatingPanel() {
        
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentReplanController") as? ContentReplanController else { return }
        
        contentVC.delegatePassData = self
        
        contentVC.dataDidFilter_Content = dataDidFilter_Replan  // da duoc loc
        // contentVC.listExcludeLocation = listExcludeLocation  // chuyen List Exclude
        contentVC.dateYMD = dateYMD
        contentVC.selectedIdxDate = selectedIdxDate
        contentVC.selectedIdxDriver = selectedIdxDriver
        contentVC.indxes = indxes
        
        // contentVC.listMoveTo = listMoveToLocation
        // contentVC.arrAssetID = arrAssetID
        
        fpc.contentMode = .fitToBounds
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
        fpc.trackingScrollView?.automaticallyAdjustsScrollIndicatorInsets = false
        
        // self.view.insertSubview(viewBtnAnimation, belowSubview: contentVC.myTableView )
        // fpc.trackingScrollView?.isScrollEnabled = true
        
        self.view.bringSubviewToFront(btnClear)
        self.view.bringSubviewToFront(btnReplace)
    }
    
    func getDataFiltered(date: Date, driver: Int) -> [Location] {
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
        
        self.selectedIdxDriver = driver
        self.pickerDriver.reloadAllComponents()
        dataDidFilter_Replan = locationsByDriver[driver] ?? []
        
        if dataDidFilter_Replan.isEmpty {  // hom dau khong co data
            // value 6 ngay con lai
           
            for idic in dicData {
                print(idic.key)
                print(dateYMD[0])
                if idic.key != dateYMD[0] {
                    print("\(idic.key)::\(idic.value)")
                    for ilocation in idic.value where ilocation.elem?.location?.metadata?.display_data?.moveToFirstDay == true {
                        listMoveToIsTrue.append(ilocation)
                    }
                }
                
            }
            
            
            print(listMoveToIsTrue.count)
            dataDidFilter_Replan = listMoveToIsTrue
        } else if dataDidFilter_Replan.isEmpty && selectedIdxDate == 0 && selectedIdxDriver + 1 == indxes.count + 1 {  // driver Remove Date 1
            dataDidFilter_Replan = listRemove
        }
        
        print(dataDidFilter_Replan)
        if dataDidFilter_Replan.count > 0 {
            btnReplace.isHidden = false
            btnClear.isHidden = false
            totalType(EachType: 0)
            self.floatingPanel()
        } else {
            fpc.removePanelFromParent(animated: true)
            btnReplace.isHidden = true
            btnClear.isHidden = true
        }
        
        self.createViewBtnAnimation()
        return dataDidFilter_Replan
    }
    
    // create button with code
    func createViewBtnAnimation() {
        viewAnimation.isHidden = false
        viewBtnAnimation.backgroundColor = .white
        viewBtnAnimation.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        viewBtnAnimation.setImage(UIImage(named: "upAnimation"), for: .normal)
        //viewBtnAnimation.frame = CGRect(x: 0, y: 270, width: self.viewAnimation.frame.size.width, height: 30)
        self.view.insertSubview(viewBtnAnimation, aboveSubview: viewAnimation)
        let verticalConstraint = NSLayoutConstraint(item: viewBtnAnimation, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewAnimation, attribute: NSLayoutConstraint.Attribute.bottom , multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: viewBtnAnimation, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.viewAnimation.frame.size.width )
        let heightConstraint = NSLayoutConstraint(item: viewBtnAnimation, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 30)
        viewBtnAnimation.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([verticalConstraint, widthConstraint, heightConstraint])
    }
    
    @objc func clickBtn() {
        status = !status
        //let horizontalConstraint = NSLayoutConstraint(item: viewBtnAnimation, attribute: NSLayoutConstraint.Attribute.leading , relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewAnimation, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: viewBtnAnimation, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewAnimation, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: viewBtnAnimation, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.viewAnimation.frame.size.width )
        let heightConstraint = NSLayoutConstraint(item: viewBtnAnimation, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 30)
        
        if status {
            // view Animation hidden
            viewAnimation.isHidden = true
            viewBtnAnimation.setImage(UIImage(named: "downAnimation"), for: .normal)
            viewBtnAnimation.frame = CGRect(x: 0, y: 161, width: self.viewAnimation.frame.width, height: 30)
            viewBtnAnimation.translatesAutoresizingMaskIntoConstraints = true
            //view.addConstraints([verticalConstraint, widthConstraint, heightConstraint])
            //view.insertSubview(viewBtnAnimation, belowSubview: viewAnimation)
        } else {
            // view Animation Display
            // viewBtnAnimation.removeConstraints([verticalConstraint, widthConstraint, heightConstraint])
            viewAnimation.isHidden = false
            viewBtnAnimation.setImage(UIImage(named: "upAnimation"), for: .normal)
            viewBtnAnimation.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints([verticalConstraint, widthConstraint, heightConstraint])
            //viewBtnAnimation.translatesAutoresizingMaskIntoConstraints = false
            // view.addConstraints([verticalConstraint, widthConstraint, heightConstraint])
            //viewBtnAnimation.frame = CGRect(x: 0, y: 270, width: self.viewAnimation.frame.size.width, height: 30)
            //  view.addSubview(viewBtnAnimation)
        }
    }
    
    enum quantityOfEachType {
        case lblType50kg
        case lblType30kg
        case lblType25kg
        case lblType20kg
        case lblTypeOther
    }
    
    func totalType(EachType: Int) -> quantityOfEachType  {
        var numberType50: Int = 0
        var numberType30: Int = 0
        var numberType25: Int = 0
        var numberType20: Int = 0
        var numberTypeOther: Int = 0
        
        arrFacilityData.removeAll()
        for facilityData in dataDidFilter_Replan {
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
        lblTypeOther.text = "\(numberTypeOther)"
        
        return .lblTypeOther
    }
}

extension ReplanController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerDriver {
            if indxes.count > 0 {
                if !listRemove.isEmpty {
                    return indxes.count + 1
                } else  {
                    return indxes.count
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
        var arrCar: [String] = []
        if pickerView == pickerDriver {
            if !indxes.isEmpty {  // co data
                if selectedIdxDate == 0 {  // ngay dau tien
                    if listRemove.isEmpty && selectedIdxDate == 0 {
                        for (ind, _) in indxes.enumerated() {
                            arrCar.append("Car\(ind + 1)")
                        }
                        return arrCar[row]
                    } else if selectedIdxDate == 0 && !listRemove.isEmpty {  // co ds Remove
                        for (ind, _) in indxes.enumerated() {
                            arrCar.append("Car\(ind + 1)")
                        }
                        arrCar.append("Remove")
                        return arrCar[row]
                    }
                    return "Car1"
                } else if selectedIdxDate > 0 {  // ngay sau
                    for (ind, _) in indxes.enumerated() {
                        arrCar.append("Car\(ind + 1)")
                    }
                    arrCar.append("Remove")
                    return arrCar[row]
                }
                
            }
            
        } else if pickerView == pickerDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            let dateString: String = formatter.string(from: dateYMD[row])
            return dateString
        }
        return "Car1"
    }

    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerDate {
            selectedIdxDate = row
            selectedIdxDriver = 0
            self.reDrawMarkers()
            listMoveToIsTrue.removeAll()
            //self.floatingPanel()
            listIndex.removeAll()
        } else if pickerView == pickerDriver {
            listIndex.removeAll()
            selectedIdxDriver = row
            self.reDrawMarkers()
           // self.floatingPanel()
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
    
    func reDrawMarkers() {
        dataDidFilter_Replan.removeAll()
        arrLocationOrder.removeAll()
        if mapView != nil {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        dataDidFilter_Replan = getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver)
        
        
        
        // them du lieu vao Driver Remove
        if selectedIdxDate == 0 && selectedIdxDriver + 1 == indxes.count + 1 {
            dataDidFilter_Replan = listRemove
        }
        
        // them du lieu vao Drive cuoi ngay 1
        var arrMoveToIsTrue = [Location]()
        for idic in dicData {
            for (ind, _) in dateYMD.enumerated() {
                if idic.key == dateYMD[ind] {
                    for iLocation in idic.value where iLocation.elem?.location?.metadata?.display_data?.moveToFirstDay == true {
                        arrMoveToIsTrue.append(iLocation)
                    }
                }
            }
        }
        
        if selectedIdxDate == 0 && selectedIdxDriver+1 == indxes.count {
            dataDidFilter_Replan.insert(contentsOf: arrMoveToIsTrue, at: dataDidFilter_Replan.count - 1)
        }
        
        
        for i in dataDidFilter_Replan {
            print("excludeFirstDay: \(i.elem?.location?.metadata?.display_data?.excludeFirstDay)")
        }
        for i in dataDidFilter_Replan {
            print("moveToFirstDay: \(i.elem?.location?.metadata?.display_data?.moveToFirstDay)")
        }
        
        if dataDidFilter_Replan.count == 0 {
            lblType50kg.text = "\(0)"
            lblType30kg.text = "\(0)"
            lblType25kg.text = "\(0)"
            lblType20kg.text = "\(0)"
            lblTypeOther.text = "\(0)"
            self.showAlert(message: "không có khách hàng nào")
        } else {  // Marker in MKMap
            for picker in dataDidFilter_Replan {  // EXCLUDE
                if picker.type == .customer && selectedIdxDriver + 1 < indxes.count + 1 && picker.elem?.location?.metadata?.display_data?.excludeFirstDay != true {
                    if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                        let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                        arrLocationOrder.append(locationOfCustomer.title)
                        mapView.addAnnotation(locationOfCustomer)
                    }
                } else if selectedIdxDriver + 1 == indxes.count + 1 && selectedIdxDate == 0 && picker.type == .customer && picker.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                    if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                        let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                        arrLocationOrder.append(locationOfCustomer.title)
                        mapView.addAnnotation(locationOfCustomer)
                    }
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
                dequeuedView.lblView.text = "\(annotation.title - 1)"
                dequeuedView.image = UIImage(named: "marker")
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
            if arrLocationOrder[0] == annotation.title {
                view.lblView.text = "\(annotation.title - 1)"
                view.zPriority = MKAnnotationViewZPriority.max
                view.image = UIImage(named: "marker")
            } else {
                view.lblView.text = "\(annotation.title - 1)"
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
        if selectedIdxDate > 0 {
            for (ind, value) in dataDidFilter_Replan.enumerated() {
                for iIndex in listIndex {
                    if iIndex == ind {
                        value.elem?.location?.metadata?.display_data?.moveToFirstDay = true
                    }
                }
            }
        }
        
        if selectedIdxDate == 0 && selectedIdxDriver+1 == indxes.count {  // xe cuoi cung , ngay 1
            for (ind, value) in dataDidFilter_Replan.enumerated() {
                for iIndex in listIndex {
                    if iIndex == ind {
                        value.elem?.location?.metadata?.display_data?.moveToFirstDay = false
                        dataDidFilter_Replan = dataDidFilter_Replan.filter { location in
                            return location.elem?.location?.metadata?.display_data?.excludeFirstDay == true
                        }
                    }
                }
            }
            
        }
        
//        if !listIndex.isEmpty {
//            for iStorage in listLocation {
//                if iStorage.key == 0 {  // ngay 1
//                    if selectedIdxDriver+1 <= indxes.count {  // cac xe trong ngay
//                        storageListExclude = iStorage.value
//                        for iExclude in iStorage.value where iExclude.elem?.location?.metadata?.display_data?.excludeFirstDay != true {
//                            iExclude.elem?.location?.metadata?.display_data?.excludeFirstDay = true
//                        }
//
//                        for iMoveTo in iStorage.value where iMoveTo.elem?.location?.metadata?.display_data?.moveToFirstDay == true {
//                            iMoveTo.elem?.location?.metadata?.display_data?.moveToFirstDay = false
//                        }
//
//
//
//                    } else if selectedIdxDriver+1 == indxes.count + 1 {  // loai bo khoi DS Remove
//                        for iExclude in iStorage.value where iExclude.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
//
//                            iExclude.elem?.location?.metadata?.display_data?.excludeFirstDay = false
//                        }
//                    }
//
//                }
//
//                // ngay tiep theo
//                if iStorage.key > 0 {  // MoveTo = false || nil --> True
//                    for iMoveTo in iStorage.value where iMoveTo.elem?.location?.metadata?.display_data?.moveToFirstDay != true {
//                        for idic in dicData {
//                            for ivalue in idic.value where ivalue == iMoveTo {
//                                ivalue.elem?.location?.metadata?.display_data?.moveToFirstDay = true
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
        dataDidFilter_Replan = dataDidFilter_Replan.filter( { !storageListExclude.contains($0) } )

        
        // tao driver Remove
        for idic in dicData where idic.key == dateYMD[0] {
            pickerDriver.reloadAllComponents()
            for ivalue in idic.value where ivalue.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                listRemove.append(ivalue)
            }
        }
        
        
        // ve lai marker
        // danh so lai LocationOrder
        mapView.removeAnnotations(mapView.annotations)
        if !listIndex.isEmpty && !storageListExclude.isEmpty {  // ve ra exclude
            for picker in dataDidFilter_Replan where picker.type == .customer {
                if  picker.elem?.location?.metadata?.display_data?.excludeFirstDay !=  true {
                    if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let order = picker.elem?.locationOrder {
                        let locationOfCustomer = CustomPin(title: order, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                        arrLocationOrder.append(locationOfCustomer.title)
                        mapView.addAnnotation(locationOfCustomer)
                    }
                }
                //                else if  picker.elem?.location?.metadata?.display_data?.excludeFirstDay == true {
                //                    if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let order = picker.elem?.locationOrder {
                //                        let locationOfCustomer = CustomPin(title: order, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                //                        arrLocationOrder.append(locationOfCustomer.title)
                //                        mapView.addAnnotation(locationOfCustomer)
                //                    }
                //                }
            }
        } else if listIndex.count > 0 {  // move to
            for picker in dataDidFilter_Replan {
                if picker.type == .customer && picker.elem?.location?.metadata?.display_data?.moveToFirstDay !=  true {
                    if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let order = picker.elem?.locationOrder {
                        let locationOfCustomer = CustomPin(title: order, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                        arrLocationOrder.append(locationOfCustomer.title)
                        mapView.addAnnotation(locationOfCustomer)
                    }
                }
            }
        }
        
        // locationDidSelected.removeAll()
        guard let contentVC2 = storyboard?.instantiateViewController(withIdentifier: "ContentReplanController") as? ContentReplanController else { return }
        contentVC2.delegatePassData = self
        print(dataDidFilter_Replan)
        contentVC2.dataDidFilter_Content = dataDidFilter_Replan
        //        contentVC2.backList = arrLocationRemoveISTrue
        
        //        contentVC2.listExcludeLocation = listExcludeLocation
        //        contentVC2.dateYMD = dateYMD
        
        contentVC2.selectedIdxDate = selectedIdxDate
        //        contentVC2.selectedIdxDriver = selectedIdxDriver
        //        contentVC2.indxes = indxes
        
        fpc.contentMode = .fitToBounds
        fpc.set(contentViewController: contentVC2)
        fpc.addPanel(toParent: self)
        
        // listExcludeLocation.removeAll()
        // dataDidFilter_Replan.removeAll()
        // self.floatingPanel()
    }
}
