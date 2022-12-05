//
//  CustomerLocationController.swift
//  Gas
//
//  Created by Vuong The Vu on 03/10/2022.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit
import FloatingPanel
import Contacts

class CustomerLocationController: UIViewController, MKMapViewDelegate, PassInfoOneCustomerDelegateProtocol {
    
    var pageIndex: Int!
    var coordinateCustomer: [Double] = UserDefaults.standard.value(forKey: "coordinateCustomer") as! [Double]
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    var mapLat: CLLocationDegrees = 0.0
    var mapLong: CLLocationDegrees = 0.0
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var btnSelectedPositionCustomer: UIButton!
    
    @IBOutlet weak var switchAutomaticGetInfoPosition: UISwitch!
    @IBAction func btnLocationGPS(_ sender: Any) {
        print("click vao GPS")
    }
    
    @IBAction func btnSaveNewPosition(_ sender: Any) {
        let alert = UIAlertController(title: "Thông báo ", message: "Có muốn thay đổi vị trí khách hàng không", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.updateCoordinateOfCustomer()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        btnSelectedPositionCustomer.isEnabled = false
        switchAutomaticGetInfoPosition.setOn(false, animated: true)
        let userCoordinate = CLLocationCoordinate2D(latitude: coordinateCustomer[1], longitude: coordinateCustomer[0])
        let eyeCoordinate = CLLocationCoordinate2D(latitude: coordinateCustomer[1], longitude: coordinateCustomer[0])
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 100.0)
        mapView.setCamera(mapCamera, animated: false)
        addAnnotation()
    }
   
    // MARK: Draw position in map
    func passCoordinateOfCustomer(coordinateCustomer: [Double]) {
        UserDefaults.standard.removeObject(forKey: "coordinateCustomer")
        UserDefaults.standard.set(coordinateCustomer, forKey: "coordinateCustomer")
    }
    
    func addAnnotation() {
        let locationOfCustomer = CustomPin(title: 0 , coordinate: CLLocationCoordinate2D(latitude: coordinateCustomer[1], longitude: coordinateCustomer[0]))
        mapView.addAnnotation(locationOfCustomer)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomPin else { return nil }
        let identifier = "Annotation"
        var view: MyPinView
        view = MyPinView(annotation: annotation, reuseIdentifier: identifier)
        view.zPriority = MKAnnotationViewZPriority.max
        view.image = UIImage(named: "marker")
        view.lblView.text = "C"
        
        return view
    }
    
    
    // MARK: Update coordinate of customer
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    func passiassetID(iassetID: String) {
        UserDefaults.standard.removeObject(forKey: "iassetID")
        UserDefaults.standard.set(iassetID, forKey: "iassetID")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        mapLat = center.latitude
        mapLong = center.longitude
    }
    
    func updateCoordinateOfCustomer() {
        
        let iassetID = UserDefaults.standard.string(forKey: "iassetID") ?? ""
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        let parameters: [String: [Double]] = ["customer_location": [mapLong, mapLat]]
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        print(token)
        print(mapLat)
        print(mapLong)
        AF.request(urlGetAsset, method: .patch, parameters: parameters, encoding: URLEncoding.httpBody, headers: self.makeHeaders(token: token)).validate(statusCode: (200...299))
            .response { response1 in
                
                print(response1.response?.statusCode ?? 0)
                switch response1.result {
                case .success( let value):
                    
                    print("value: \(value)")
                    let FloatingPanel = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
                    self.navigationController?.setViewControllers([FloatingPanel], animated: true)
                    self.hideActivity()
                    
                case .failure(let error):
                    print("\(error)")
                    self.hideActivity()
                }
            }
        
    }
    
    
    
    func passCoordinate(coordinate: [Double]) {
        //
    }
}
