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
    var dicDataReplan: [Date : [Location]] = [:]
    var dateYMD: [Date] = []
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    var dataDidFilter = [Location]()
    var indxes = [Int]()
    var selectedIdxDate = 0
    var selectedIdxDriver = 0
    var arrLocationOrder = [Int]()
    var arrFacilityData: [[Facility_data]] = []

    var numberCustomer = 0
    var arrAssetID = [String]()
    var arrAssetIDDidSelected = [String]()
    var selectedRows1: [Int] = []
    
    @IBOutlet weak var btnClear: UIButton!
    @IBAction func btnClear(_ sender: Any) {
        print("bo chon")
        let view = fpc.contentViewController as! ContentReplanController
        totalCellSelect = 0
        view.selectedRows.removeAll()
        view.myTableView.reloadData()
    }
    
    @IBOutlet weak var btnReplace: UIButton!
    @IBAction func btnReplace(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let dateString: String = formatter.string(from: dateYMD[0])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "CustomAlertReplanVC") as! CustomAlertReplanVC
        destinationVC.delegateClickOK = self
        destinationVC.selectedIdxDate = selectedIdxDate
        destinationVC.totalCellSelect = totalCellSelect
        destinationVC.t = numberCustomer
        destinationVC.date = dateString
        present(destinationVC, animated: false, completion: nil)
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
        contentVC.dataDidFilter = dataDidFilter
        
        contentVC.selectedIdxDate = selectedIdxDate
        contentVC.selectedRows1 = selectedRows1
        contentVC.arrAssetID = arrAssetID
        fpc.contentMode = .fitToBounds
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
        //        self.present(fpc, animated: true)
        fpc.trackingScrollView?.automaticallyAdjustsScrollIndicatorInsets = true
        
        
        
        // self.view.insertSubview(viewBtnAnimation, belowSubview: contentVC.myTableView )
        //        fpc.trackingScrollView?.isScrollEnabled = true
        
        self.view.bringSubviewToFront(btnClear)
        self.view.bringSubviewToFront(btnReplace)
       // self.locationDidSelected()
    }
    
    func getDataFiltered(date: Date, driver: Int) -> [Location] {
        
        var locationsByDriver: [Int: [Location]] = [:]
        var elemLocationADay = dicDataReplan[date] ?? []
        
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
        dataDidFilter = locationsByDriver[driver] ?? []
        
        if dataDidFilter.count > 0 {
            for i in dataDidFilter {
                arrAssetID.append(i.elem?.location?.assetID ?? "")
            }
            btnReplace.isHidden = false
            btnClear.isHidden = false
            self.totalType(EachType: .lblTypeOther)
            self.floatingPanel()
        } else {
            fpc.removePanelFromParent(animated: true)
            btnReplace.isHidden = true
            btnClear.isHidden = true
        }
        
        self.createViewBtnAnimation()
        return dataDidFilter
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
    
    func totalType(EachType: quantityOfEachType) -> Int {
        var numberType50: Int = 0
        var numberType30: Int = 0
        var numberType25: Int = 0
        var numberType20: Int = 0
        var numberTypeOther: Int = 0
        
        
        arrFacilityData.removeAll()
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
        lblTypeOther.text = "\(numberTypeOther)"
        
        return 0
    }
}

extension ReplanController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerDriver {
            if indxes.count == 0 {
                return 1
            }
            return indxes.count
        } else if pickerView == pickerDate {
            return dateYMD.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerDriver {
            return car[row]
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
            selectedIdxDriver = 0
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
        dataDidFilter.removeAll()
        arrLocationOrder.removeAll()
        numberCustomer = 0
        
        if mapView != nil {
            mapView.removeAnnotations(mapView.annotations)
        }
        dataDidFilter = getDataFiltered(date: dateYMD[selectedIdxDate], driver: selectedIdxDriver)
        if dataDidFilter.count == 0 {
            lblType50kg.text = "\(0)"
            lblType30kg.text = "\(0)"
            lblType25kg.text = "\(0)"
            lblType20kg.text = "\(0)"
            lblTypeOther.text = "\(0)"
            print("_______________________________________________________________________________Không có đơn hàng nào!")
            self.showAlert(message: "không có khách hàng nào")
        } else {
            
            //            let dataDidFilter1 = dataDidFilter.sorted(by: { $0.elem?.locationOrder ?? 0 > $1.elem?.locationOrder ?? 0 })
            
            for picker in dataDidFilter where picker.type == .customer  {
                numberCustomer += 1
                if let lat = picker.elem?.latitude, let long = picker.elem?.longitude, let locationOrder = picker.elem?.locationOrder {
                    let locationOfCustomer = CustomPin(title: locationOrder , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    arrLocationOrder.append(locationOfCustomer.title)
                    
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

extension ReplanController: InfoACellDelegateProtocol {
    // delegateContenReplant
    func unselected(index: Int, assetID: String) {
        totalCellSelect -= 1
        if !selectedRows1.isEmpty {
            selectedRows1.enumerated().forEach() { ind, value in
                if value == index {
                    selectedRows1.remove(at: ind)
                }
            }
        }
        
        if !arrAssetIDDidSelected.isEmpty {
            arrAssetIDDidSelected.enumerated().forEach() { ind, value in
                if value == assetID {
                    arrAssetIDDidSelected.remove(at: ind)
                }
            }
        }
    }
    
    func passData(index: Int, assetID: String) {
        
        selectedRows1.append(index)
        totalCellSelect += 1
        arrAssetIDDidSelected.append(assetID)
    }
    
    
//    func locationDidSelected() {
//
//        // chuyen khach hang tu ngay sau -> ngay dau tien
//        var dataForAday: [Location] = dicDataReplan[dateYMD[selectedIdxDate]] ?? []
//
//        // xoa cac phan tu duoc chon
//        if !arrAssetIDDidSelected.isEmpty {
//            for iassetID in arrAssetIDDidSelected {
//                arrAssetID.enumerated().forEach { idx, ivalue in
//                    if ivalue == iassetID {
//                        print(ivalue)
//
//
//                        // luu vao properties
//                        //                        var detailLocation = LocationOfReplan(elem: <#LocationElement#>, asset: <#GetAsset#>)
//                        //                        detailLocation.elem =
//
//                        // xoa trong mang cac iassetID nay trong [Location]
//                        // dataForAday.remove(at: idx)
//                        // dataForAday.enumerated().forEach { ind, ivalue in
//                        //    print("\(ind)-> \(ivalue)")
//                        // }
//                    }
//                }
//            }
//        }
//
//
//        // them cac phan tu -> vao cuoi ngay 1
//        // dicDataReplan.updateValue(, forKey: dateYMD[0])
//
//        //        dicDataReplan[dateYMD[0]] = []
//    }
    
    
}


extension ReplanController: ClickOkDelegateProtocol {
    // truyen vi tri cac cell  da ddc chon sang ContentReplanVC --> to mau
    
    func clickOk() {
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentReplanController") as? ContentReplanController else { return }
        
        contentVC.delegateContenReplant = self
        contentVC.dataDidFilter = dataDidFilter
        contentVC.selectedIdxDate = selectedIdxDate
        contentVC.selectedRows1 = selectedRows1
        contentVC.arrAssetIDDidSelected = arrAssetIDDidSelected 
        contentVC.arrAssetID = arrAssetID
        
        fpc.contentMode = .fitToBounds
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
        //        self.present(fpc, animated: true)
        fpc.trackingScrollView?.automaticallyAdjustsScrollIndicatorInsets = true
        
        // self.view.insertSubview(viewBtnAnimation, belowSubview: contentVC.myTableView )
        //        fpc.trackingScrollView?.isScrollEnabled = true
        
        self.view.bringSubviewToFront(btnClear)
        self.view.bringSubviewToFront(btnReplace)
       // self.locationDidSelected()
    }
    
    
    
}



