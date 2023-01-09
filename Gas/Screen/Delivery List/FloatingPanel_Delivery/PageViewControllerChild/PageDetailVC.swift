//
//  PageFristVC.swift
//  Gas
//
//  Created by Vuong The Vu on 05/10/2022.
//

import UIKit
import Alamofire
import FloatingPanel
import AlamofireImage


protocol PassInfoOneCustomerDelegateProtocol: AnyObject {
    func passiassetID(iassetID: String)
    func passCoordinate(coordinate: [Double])
    func passCoordinateOfCustomer(coordinateCustomer: [Double])
}

protocol PassImageDelegateProtocol: AnyObject {
    func passUrlGasLocation1(urlImage1: String)
    func passUrlGasLocation2(urlImage2: String)
    func passUrlGasLocation3(urlImage3: String)
    func passUrlGasLocation4(urlImage4: String)
    
    func passUrlParkingPlace5(urlImage5: String)
    func passUrlParkingPlace6(urlImage6: String)
    func passUrlParkingPlace7(urlImage7: String)
    func passUrlParkingPlace8(urlImage8: String)
    func passNotes(notes: String)
}

//protocol PassAssetDelegateProtocol: AnyObject {
//    func passAssetOfCustomer(asset: AnyObject)
//}

class PageDetailVC: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate {
    
    weak var delegatePassInfoOneCustomer: PassInfoOneCustomerDelegateProtocol?
    weak var delegatePassImage: PassImageDelegateProtocol?
    //    weak var delegatePassAsset: PassAssetDelegateProtocol?
    
    var pageIndex: Int!
    var comment: String = ""
    var arrUrlImage: [[String]] = []
    var dateYMD: [Date] = []
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    var dicData: [Date : [LocationElement]] = [:]
    var locations: [LocationElement] = []
    var totalObjectSevenDate: Int = 0
    var arrCustomer_id: [String] = []
    var data: [String] = []
    var arrFacilityData = [[Facility_data]]()
    var arrImage = [String]()
    var dataInfoOneCustomer: Location = Location(elem: LocationElement(arrivalTime: nil, breakTimeSEC: nil, createdAt: nil, latitude: 0, loadCapacity: 0, loadSupply: 0, location: nil, locationID: 0, locationOrder: 0, longitude: 0, metadata: nil, travelTimeSECToNext: 0, waitingTimeSEC: 0, workTimeSEC: 0), asset: GetAsset(assetModelID: 0, createdAt: "", enabled: true, geoloc: nil, id: "", metedata: "", name: "", properties: nil, tenantID: 0, updatedAt: "", version: 0, vendorThingID: ""))
    
    @IBOutlet weak var viewContainerScrollview: UIScrollView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblCustomer_id: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblAstimateDelivery: UILabel!
    @IBOutlet weak var lblTypeGas: UILabel!
    @IBOutlet weak var lblNumberGas: UILabel!
    @IBOutlet weak var viewAutomaticInfoGas: UIView!
    @IBOutlet weak var lblTypeGasInStackView: UILabel!
    @IBOutlet weak var lblNumberGasInStackView: UILabel!
    @IBOutlet weak var lblTextNotes: UITextView!
    @IBOutlet weak var viewImageScroll: UIScrollView!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var viewNote: UIView!
    
    
    @IBAction func btnEdit(_ sender: Any) {
        print("click Edit")
        let screenEdit = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        self.navigationController?.pushViewController(screenEdit, animated: true)
    }
    
    @IBAction func pageControlDidPage(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTextNotes.isEditable = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.numberOfPages = arrImage.count

        guard let parkingVC = storyboard?.instantiateViewController(withIdentifier: "ParkingLocationController") as? ParkingLocationController else { return }
        delegatePassInfoOneCustomer = parkingVC
        if let mapCoordinate = dataInfoOneCustomer.asset?.properties?.values.location?.coordinates,
           let iassetID = dataInfoOneCustomer.elem?.location?.assetID {
            delegatePassInfoOneCustomer?.passiassetID(iassetID: iassetID )
            delegatePassInfoOneCustomer?.passCoordinate(coordinate: mapCoordinate)
        }
        
        guard let customerLocation = storyboard?.instantiateViewController(withIdentifier: "CustomerLocationController") as? CustomerLocationController else { return }
        delegatePassInfoOneCustomer = customerLocation
        
        if let mapCoordinateCustomer = dataInfoOneCustomer.asset?.properties?.values.customer_location,
           let iassetID = dataInfoOneCustomer.elem?.location?.assetID {
            delegatePassInfoOneCustomer?.passiassetID(iassetID: iassetID)
            delegatePassInfoOneCustomer?.passCoordinateOfCustomer(coordinateCustomer: mapCoordinateCustomer)
        }
        
        guard let generalInforVC = storyboard?.instantiateViewController(withIdentifier: "GeneralInfoController") as? GeneralInfoController else { return }
        delegatePassImage = generalInforVC
        
        if let gasLocation1 = dataInfoOneCustomer.asset?.properties?.values.gas_location1,
           let gasLocation2 = dataInfoOneCustomer.asset?.properties?.values.gas_location2,
           let gasLocation3 = dataInfoOneCustomer.asset?.properties?.values.gas_location3,
           let gasLocation4 = dataInfoOneCustomer.asset?.properties?.values.gas_location4,
           let parkingPlace5 = dataInfoOneCustomer.asset?.properties?.values.parking_place1,
           let parkingPlace6 = dataInfoOneCustomer.asset?.properties?.values.parking_place2,
           let parkingPlace7 = dataInfoOneCustomer.asset?.properties?.values.parking_place3,
           let parkingPlace8 = dataInfoOneCustomer.asset?.properties?.values.parking_place4,
           let notes = dataInfoOneCustomer.asset?.properties?.values.notes {
            
            delegatePassImage?.passUrlGasLocation1(urlImage1: gasLocation1)
            delegatePassImage?.passUrlGasLocation2(urlImage2: gasLocation2)
            delegatePassImage?.passUrlGasLocation3(urlImage3: gasLocation3)
            delegatePassImage?.passUrlGasLocation4(urlImage4: gasLocation4)
            
            delegatePassImage?.passUrlParkingPlace5(urlImage5: parkingPlace5)
            delegatePassImage?.passUrlParkingPlace6(urlImage6: parkingPlace6)
            delegatePassImage?.passUrlParkingPlace7(urlImage7: parkingPlace7)
            delegatePassImage?.passUrlParkingPlace8(urlImage8: parkingPlace8)
            
            delegatePassImage?.passNotes(notes: notes)
        }
        
        
        if dataInfoOneCustomer.type == .supplier {
            lblCustomer_id?.text = comment
            lblCustomerName.removeFromSuperview()
            lblAddress.removeFromSuperview()
            lblDeliveryTime.removeFromSuperview()
            lblAstimateDelivery.removeFromSuperview()
            collectionView.removeFromSuperview()
            viewImageScroll.removeFromSuperview()
            viewNote.removeFromSuperview()
            viewDetail.removeFromSuperview()
            viewType.removeFromSuperview()
            
        } else {
            
            lblCustomer_id?.text = dataInfoOneCustomer.elem?.location?.comment
            lblCustomerName?.text = dataInfoOneCustomer.asset?.properties?.values.customer_name
            lblAddress?.text = dataInfoOneCustomer.asset?.properties?.values.address
            if let minutes = dataInfoOneCustomer.elem?.arrivalTime?.minutes,
               let hours = dataInfoOneCustomer.elem?.arrivalTime?.hours {
                if minutes < 10 {
                    lblDeliveryTime?.text = "Estimate Time : \(hours):0\(minutes)"
                } else {
                    lblDeliveryTime?.text = "Estimate Time : \(hours):\(minutes)"
                }
            }
            arrImage.removeAll()
            if let gasLocation1 = dataInfoOneCustomer.asset?.properties?.values.gas_location1,
               let gasLocation2 = dataInfoOneCustomer.asset?.properties?.values.gas_location2,
               let gasLocation3 = dataInfoOneCustomer.asset?.properties?.values.gas_location3,
               let gasLocation4 = dataInfoOneCustomer.asset?.properties?.values.gas_location4,
               let parkingPlace1 = dataInfoOneCustomer.asset?.properties?.values.parking_place1,
               let parkingPlace2 = dataInfoOneCustomer.asset?.properties?.values.parking_place2,
               let parkingPlace3 = dataInfoOneCustomer.asset?.properties?.values.parking_place3,
               let parkingPlace4 = dataInfoOneCustomer.asset?.properties?.values.parking_place4 {
                
                if !gasLocation1.isEmpty || !gasLocation2.isEmpty || !gasLocation3.isEmpty || !gasLocation4.isEmpty || !parkingPlace1.isEmpty || !parkingPlace2.isEmpty || !parkingPlace3.isEmpty || !parkingPlace4.isEmpty {
                    arrImage.append(gasLocation1)
                    arrImage.append(gasLocation2)
                    arrImage.append(gasLocation3)
                    arrImage.append(gasLocation4)
                    arrImage.append(parkingPlace1)
                    arrImage.append(parkingPlace2)
                    arrImage.append(parkingPlace3)
                    arrImage.append(parkingPlace4)
                }
            }
            arrUrlImage.append(arrImage)
            arrFacilityData.append(dataInfoOneCustomer.elem?.metadata?.facility_data ?? [])
            
            for iFacilityData in arrFacilityData {
                if iFacilityData.count == 1 {
                    lblTypeGas?.text = "\(iFacilityData[0].type ?? 0)kg"
                    lblNumberGas?.text = "\(iFacilityData[0].count  ?? 0)bottle"
                    viewAutomaticInfoGas.removeFromSuperview()
                    
                } else if iFacilityData.count > 1 {
                    self.view.addSubview(viewAutomaticInfoGas)
                    viewAutomaticInfoGas.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        viewAutomaticInfoGas.bottomAnchor.constraint(equalTo: viewDetail.bottomAnchor),
                        viewAutomaticInfoGas.leftAnchor.constraint(equalTo: viewDetail.leftAnchor, constant: 40),
                        viewAutomaticInfoGas.rightAnchor.constraint(equalTo: viewDetail.rightAnchor, constant: -40),
                        viewAutomaticInfoGas.heightAnchor.constraint(equalToConstant: 30)
                    ])
                    
                    lblTypeGas?.text = "\(iFacilityData[0].type ?? 0 )kg"
                    lblNumberGas?.text =  "\(iFacilityData[0].count  ?? 0)bottle"
                    lblTypeGasInStackView.text = "\(iFacilityData[1].type ?? 0 )kg"
                    lblNumberGasInStackView.text = "\(iFacilityData[1].count  ?? 0)bottle"
                }
            }
            
            if dataInfoOneCustomer.asset?.properties?.values.notes != "" {
                lblTextNotes.text = dataInfoOneCustomer.asset?.properties?.values.notes
            } else {
                lblTextNotes.text = " Hiển thị ra cho có, khi Notes không có cái gì"
            }
            
            lblAstimateDelivery?.text = dataInfoOneCustomer.elem?.metadata?.planned_date
            
            var arrDataUrlImage = [String]()
            for iUrlImage in arrImage where iUrlImage != "" {
                arrDataUrlImage.append(iUrlImage)
            }
            arrImage = arrDataUrlImage
        }
    }
    
    
    func scrollViewDidEndDecelerating(scrollImage: UIScrollView) {
        pageControl.currentPage = Int(viewImageScroll.contentOffset.x / viewImageScroll.bounds.width)
//        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //scrollView.contentOffset.x = 0.0
        let witdh = scrollView.frame.width - (scrollView.contentInset.left * 2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl?.currentPage = Int(roundedIndex)
    }
}


extension PageDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // colection DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = arrImage.count
        pageControl.numberOfPages = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  as! PageDetailCollectionViewCell
        if !arrImage.isEmpty {
            let iurl = arrImage[indexPath.row]
            cellImage.imgImage.loadImageExtension(URLAddress: iurl)
        }
        cellImage.layer.shouldRasterize = true
        return cellImage
    }
}

