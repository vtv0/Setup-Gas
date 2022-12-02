//
//  ParkingLocationController.swift
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

class ParkingLocationController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    var pageIndex: Int!
    let locationManager = CLLocationManager()
    
    var totalObjectSevenDate: Int = 0
    var dataInfoOneCustomer: Location = Location(elem: LocationElement(locationOrder: 0), asset: GetAsset(assetModelID: 0, enabled: true))
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var btnSaveParking: UIButton!
    @IBAction func btnSaveParking(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Thông báo ", message: "Có muốn thay đổi vị trí đỗ xe không", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.putPositionParking()
            let FloatingPanel = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            self.navigationController?.setViewControllers([FloatingPanel], animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var btnLocationGPS: UIButton!
    @IBAction func btnLocationGPS(_ sender: Any) {
        print(" vi tri hien tai")
    }
    
    
    @IBOutlet weak var btnSelectedCoordinate: UIButton!
    @IBAction func btnSelectedCoordinate(_ sender: Any) {
        return mapView(mapView, regionDidChangeAnimated: true)
    }
    
    let lat = Double(UserDefaults.standard.string(forKey: "LatOfParking") ?? "") ?? 0
    let long =  Double(UserDefaults.standard.string(forKey: "LongOfParking") ?? "") ?? 0
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSelectedCoordinate.isEnabled = false
        
        
        let userCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let eyeCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 100.0)
        mapView.delegate = self
        
        mapView.setCamera(mapCamera, animated: false)
        
        addAnnotation()
        
    }
    
    func addAnnotation() {
        let locationOfCustomer = CustomPin(title: 0 , coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
        mapView.addAnnotation(locationOfCustomer)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomPin else { return nil }
        let identifier = "Annotation"
        var view: MyPinView
        view = MyPinView(annotation: annotation, reuseIdentifier: identifier)
        view.zPriority = MKAnnotationViewZPriority.max
        view.image = UIImage(named: "marker")
        view.lblView.text = "P"
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        mapLat = center.latitude
        mapLong = center.longitude
        let coordinate = "Lat: \(mapLat.formatted()) \nLong: \(mapLong.formatted())"
        
        print(coordinate)
        //        self.btnSelectedCoordinate.textInputMode = coordinate
        
    }
    var mapLat: CLLocationDegrees = 0.0
    var mapLong: CLLocationDegrees = 0.0
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    
    
    
    func putPositionParking() {
        
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let iassetID = UserDefaults.standard.string(forKey: "iassetID") ?? ""
        
        let parameters = ["properties": PropertiesDetail?.self, "values": ValuesDetail.self, "location": LocationDetail?.self, "coordinates": [Double]?.self ] as [String : Any]
        
        
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        
        
        AF.request(urlGetAsset, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetAsset.self ) { response1 in
                print(response1.response?.statusCode)
                switch response1.result {
                case .success( let value):
                    
                    print(value)
                    self.hideActivity()
                    
                    
                case .failure(let error):
                    print("\(error)")
                    
                }
            }
    }
}
