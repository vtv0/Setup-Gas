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
    var car: [String] = ["Car1", "Car2", "Car3", "Car4", "Car5", "Car6", "Car7", "Car8", "Car9"]
    let fpc = FloatingPanelController()
    var t: Int = 0
    var totalCellSelect: Int = 0
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
    
    var arrLocationRemove = [Location]()
    var arrAssetID = [String]()
    
    var listMoveToLocation = [Location]()
    var listExcludeLocation = [Location]()
    var dicMoveTo = [Int: [Location]]()
    var dicExclude = [Int: [Location]]()
    
    var dicExcludeOfDriver: [Int: [Location]] = [:]
    
    var selectedRows1: [Int] = []
    var totalNumberOfBottle = 0
    @IBOutlet weak var btnClear: UIButton!
    @IBAction func btnClear(_ sender: Any) {
        listMoveToLocation.removeAll()
        dicMoveTo.updateValue(listMoveToLocation, forKey: selectedIdxDate)
        listExcludeLocation.removeAll()
        dicExclude.updateValue(listExcludeLocation, forKey: selectedIdxDate)
        let view = fpc.contentViewController as! ContentReplanController
        view.myTableView.reloadData()
    }
    
    @IBOutlet weak var btnReplace: UIButton!
    @IBAction func btnReplace(_ sender: Any) {
        
        
        if listMoveToLocation.count > 0 || arrLocationRemove.count > 0 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "CustomAlertReplanVC") as! CustomAlertReplanVC
            destinationVC.delegateClickOK = self
            destinationVC.arrLocationRemove = arrLocationRemove
            
            destinationVC.selectedIdxDate = selectedIdxDate
            destinationVC.selectedIdxDriver = selectedIdxDriver
            destinationVC.listMoveToLocation = listMoveToLocation
            
            
            destinationVC.totalCellSelect = totalCellSelect
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
        contentVC.delegateContenReplant = self
        contentVC.delegateExclude_Replan = self
        
        contentVC.dataDidFilter_Content = dataDidFilter_Replan  //  chuyen data mac dinh || da duoc loc
        //  contentVC.listExcludeLocation = listExcludeLocation     // chuyen List Exclude
        contentVC.dateYMD = dateYMD
        contentVC.selectedIdxDate = selectedIdxDate
        contentVC.selectedIdxDriver = selectedIdxDriver
        contentVC.indxes = indxes
        //        contentVC.listMoveTo = listMoveToLocation
        
        // contentVC.listExcludeLocation = listExcludeLocation
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
        
        if dataDidFilter_Replan.count > 0   { //  locationDidSelected.count > 0 || arrLocationRemove.count > 0
            btnReplace.isHidden = false
            btnClear.isHidden = false
            self.totalType(EachType: 20)
            self.floatingPanel()
        } else {
            fpc.removePanelFromParent(animated: true)
            btnReplace.isHidden = true
            btnClear.isHidden = true
        }
        
        self.createViewBtnAnimation()
        
        if dataDidFilter_Replan.isEmpty && listMoveToLocation.count > 0 {
            dataDidFilter_Replan = listMoveToLocation
        }
        
        return dataDidFilter_Replan
    }
    
    // create button with code
    func createViewBtnAnimation () {
        
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
                if listExcludeLocation.count == 0 {
                    return indxes.count
                } else {
                    return indxes.count + 1
                }
            } else if indxes.count == 0 {
                return 1
            }
        } else if pickerView == pickerDate {
            return dateYMD.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerDriver {
            var arrCar: [String] = []
            if indxes.count > 0 {
                for (ind, _) in indxes.enumerated() {
                    arrCar.append("Car\(ind + 1)")
                }
                return arrCar[row]
            }
            return "Car1"
        } else if pickerView == pickerDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            let dateString: String = formatter.string(from: dateYMD[row])
            return dateString
        }
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerDate {
            selectedIdxDate = row
            totalCellSelect = 0
            self.reDrawMarkers()
        } else if pickerView == pickerDriver {
            selectedIdxDriver = row
            self.reDrawMarkers()
        }
    }
}

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
        
        
        if selectedIdxDate == 0 && listMoveToLocation.count > 0 && selectedIdxDriver + 1 == indxes.count {
            dataDidFilter_Replan.insert(contentsOf: listMoveToLocation, at: dataDidFilter_Replan.count - 1)
        }
        
        if listExcludeLocation.count > 0  && selectedIdxDate == 0 {
            for idicOFDriver in dicExcludeOfDriver {
                print(idicOFDriver.key)
                if selectedIdxDriver == idicOFDriver.key {
                    dataDidFilter_Replan = dataDidFilter_Replan.filter( { !idicOFDriver.value.contains($0) } )
                }
                
            }
        }
        
        
        // xoa cac diem co MoveTo == true
        
        if dataDidFilter_Replan.count == 0  && listMoveToLocation.count == 0 && listExcludeLocation.count == 0 {
            lblType50kg.text = "\(0)"
            lblType30kg.text = "\(0)"
            lblType25kg.text = "\(0)"
            lblType20kg.text = "\(0)"
            lblTypeOther.text = "\(0)"
            print("_______________________________________________________________________________Không có đơn hàng nào!")
            self.showAlert(message: "không có khách hàng nào")
        } else {
            if listExcludeLocation.count > 0 {  // EXCLUDE
                if selectedIdxDriver + 1 == indxes.count {
                    for picker in dataDidFilter_Replan {
                        if picker.type == .customer {
                            if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                                let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                                arrLocationOrder.append(locationOfCustomer.title)
                                mapView.addAnnotation(locationOfCustomer)
                            }
                        }
                    }
                } else if selectedIdxDriver + 1 == 3 {
                    for picker in listExcludeLocation where picker.type == .customer {
                        if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                            let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                            arrLocationOrder.append(locationOfCustomer.title)
                            mapView.addAnnotation(locationOfCustomer)
                        }
                    }
                }
                
            } else if listMoveToLocation.count > 0 {  // MOVE TO
                for picker in dataDidFilter_Replan {
                    if picker.type == .customer && picker.elem?.location?.metadata?.display_data?.moveToFirstDay != true {
                        if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                            let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                            arrLocationOrder.append(locationOfCustomer.title)
                            mapView.addAnnotation(locationOfCustomer)
                        }
                    }
                    
                }
                
            } else {
                for picker in dataDidFilter_Replan where picker.type == .customer {  // DEFAULT
                    if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                        let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                        arrLocationOrder.append(locationOfCustomer.title)
                        mapView.addAnnotation(locationOfCustomer)
                    }
                }
                
            }
            
        }
        //        listMoveToLocation.removeAll()
        floatingPanel()
    }
    
    
    // ve ra marker
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

extension ReplanController: ExcludeFirstDayDelegateProtocol {
    func check(isCustomer: Location, indexDriver: Int, indexDate: Int) {
        arrLocationRemove.append(isCustomer)
    }
    func uncheck(isCustomer: Location, indexDriver: Int, indexDate: Int) {
        if !arrLocationRemove.isEmpty {
            arrLocationRemove.enumerated().forEach { ind, ilocation in
                if ilocation == isCustomer {
                    arrLocationRemove.remove(at: ind)
                }
            }
        }
    }
}

extension ReplanController: MoveToFirstDayDelegateProtocol {
    // chọn trong table view cell
    func passData(isCustomer: Location, indexDate: Int, indexDriver: Int) {
        listMoveToLocation.append(isCustomer)
    }
    
    // bỏ chọn trong table view cell
    func unselected(isCustomer: Location, indexDate: Int, indexDriver: Int) {
        if !listMoveToLocation.isEmpty {
            listMoveToLocation.enumerated().forEach { ind, ilocation in
                if ilocation == isCustomer {
                    listMoveToLocation.remove(at: ind)
                }
            }
        }
    }
}

extension ReplanController: ClickOkDelegateProtocol {
    func clickOk(dicMoveTo: [Int: [Int: [Location]]], dicExclude: [Int: [Int: [Location]]]) {
        
        // bien doi Move To First day
        for idic in dicMoveTo {
            for idicOfDriver in idic.value {
                for ilocation in idicOfDriver.value where ilocation.elem?.location?.metadata?.display_data?.moveToFirstDay != true {
                    ilocation.elem?.location?.metadata?.display_data?.moveToFirstDay = true
                }
            }
        }
        
        //        for idetailMoveTo in dicMoveTo {
        //            for ivalue in idetailMoveTo.value  {
        //                print(ivalue.elem?.location?.metadata?.display_data?.moveToFirstDay)
        //            }
        //        }
        
        // them vao xe cuoi cung cua ngay 1
        if selectedIdxDate == 0 {
            dataDidFilter_Replan.insert(contentsOf: listExcludeLocation, at: dataDidFilter_Replan.count)
        }
        
        
        // chuyen ve luc dau + Exclude First Day
        // xoa ngay cac phan tu da duoc chon ow ngay 1
        
        if !dicExclude.isEmpty {
            pickerDriver.reloadAllComponents()
            for idicOfDate in dicExclude where idicOfDate.key == 0 {
                dicExcludeOfDriver = idicOfDate.value
                for idicOfDriver in idicOfDate.value {
                    listExcludeLocation = idicOfDriver.value
                    dataDidFilter_Replan = dataDidFilter_Replan.filter( { !idicOfDriver.value.contains($0) })
                }
            }
        }
        
        
        
        
        //        if selectedIdxDate > 0 {
        //            for idetailMoveTo in dicMoveTo where idetailMoveTo.key == selectedIdxDate {
        //                dataDidFilter_Replan = dataDidFilter_Replan.filter( { !idetailMoveTo.value.contains($0) })
        //            }
        //        }
        
        
        // ve lai marker
        // danh so lai LocationOrder
        mapView.removeAnnotations(mapView.annotations)
        
        if listExcludeLocation.count > 0 {  // ve ra exclude
            for picker in dataDidFilter_Replan {
                if picker.type == .customer && picker.elem?.location?.metadata?.display_data?.excludeFirstDay !=  true {
                    if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let order = picker.elem?.locationOrder {
                        let locationOfCustomer = CustomPin(title: order, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                        arrLocationOrder.append(locationOfCustomer.title)
                        mapView.addAnnotation(locationOfCustomer)
                    }
                }
            }
        } else if listMoveToLocation.count > 0 {  // move to
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
        contentVC2.delegateContenReplant = self
        contentVC2.delegateExclude_Replan = self
        contentVC2.dataDidFilter_Content = dataDidFilter_Replan
        print(listExcludeLocation)
        //        contentVC2.listExcludeLocation = listExcludeLocation
        
        
        //        contentVC2.dateYMD = dateYMD
        contentVC2.selectedIdxDate = selectedIdxDate
        //        contentVC2.selectedIdxDriver = selectedIdxDriver
        //        contentVC2.indxes = indxes
        
        fpc.contentMode = .fitToBounds
        fpc.set(contentViewController: contentVC2)
        fpc.addPanel(toParent: self)
        
        // listExcludeLocation.removeAll()
        //   dataDidFilter_Replan.removeAll()
        //  self.floatingPanel()
    }
    
    
    
}



