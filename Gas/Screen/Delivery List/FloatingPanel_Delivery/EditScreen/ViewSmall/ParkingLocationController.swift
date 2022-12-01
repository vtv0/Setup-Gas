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

class ParkingLocationController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    var pageIndex: Int!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnSaveParking: UIButton!
    @IBOutlet weak var btnLocationGPS: UIButton!
    
    @IBAction func btnSelectedCoordinate(_ sender: Any) {
        print("sssss")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.locationManager.requestAlwaysAuthorization()

            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }

            mapView.delegate = self
            mapView.mapType = .standard
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true

            if let coor = mapView.userLocation.location?.coordinate{
                mapView.setCenter(coor, animated: true)
            }

    }
    
}
    

