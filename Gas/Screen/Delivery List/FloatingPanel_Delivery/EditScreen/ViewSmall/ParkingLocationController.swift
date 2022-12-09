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

class ParkingLocationController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, PassInfoOneCustomerDelegateProtocol {
    func passCoordinateOfCustomer(coordinateCustomer: [Double]) {
        //
    }
    var pageIndex: Int!
    var mapLat: CLLocationDegrees = 0.0
    var mapLong: CLLocationDegrees = 0.0
    var iassetID: String = ""
    var coordinateParking = [Double]()
    
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnSaveParking: UIButton!
    @IBAction func btnSaveParking(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Thông báo ", message: "Có muốn thay đổi vị trí đỗ xe không", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.putPositionParking()
            
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSelectedCoordinate.isEnabled = false
        coordinateParking = UserDefaults.standard.value(forKey: "coordinate") as! [Double]
        let userCoordinate = CLLocationCoordinate2D(latitude: coordinateParking[1], longitude: coordinateParking[0])
        let eyeCoordinate = CLLocationCoordinate2D(latitude: coordinateParking[1], longitude: coordinateParking[0])
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 100.0)
        mapView.setCamera(mapCamera, animated: false)
        
        mapView.delegate = self
        addAnnotation()
    }
    
    func passCoordinate(coordinate: [Double]) {
        UserDefaults.standard.removeObject(forKey: "coordinate")
        UserDefaults.standard.set(coordinate, forKey: "coordinate")
    }
    
    func addAnnotation() {
        coordinateParking = UserDefaults.standard.value(forKey: "coordinate") as! [Double]
        
        let locationOfParking = CustomPin(title: 0 , coordinate: CLLocationCoordinate2D(latitude: coordinateParking[1], longitude: coordinateParking[0]))
        mapView.addAnnotation(locationOfParking)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        mapLat = center.latitude
        mapLong = center.longitude
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
    
    // MARK:- PUT alamofire
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    
    
    func passiassetID(iassetID: String) {
        UserDefaults.standard.removeObject(forKey: "iassetID")
        UserDefaults.standard.set(iassetID, forKey: "iassetID")
    }
    func putPositionParking() {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let iassetID = UserDefaults.standard.string(forKey: "iassetID") ?? ""
        
        let parameters: [String: [String: [String: [String: [Double]]]]] = ["properties": ["values": ["location": ["coordinates": [mapLong, mapLat] ] ] ] ]
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        self.showActivity()
        
        
        AF.request(urlGetAsset, method: .patch, parameters: parameters, encoding: CustomPATCHEncoding(), headers: self.makeHeaders(token: token)).validate(statusCode: (200...299))
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
}

struct CustomPATCHEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        let mutableRequest = try! URLEncoding().encode(urlRequest, with: parameters) as? NSMutableURLRequest
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            mutableRequest?.httpBody = jsonData
        } catch {
            print(error.localizedDescription)
        }
        
        return mutableRequest! as URLRequest
    }
}

