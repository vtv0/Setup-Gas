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
    
    func passUrlImage(urlImage: [String])
}

//protocol PassInfoCustomer: AnyObject {
//    func passInfoCustomerShipping(infoCustomer: Location)
//}

class PageDetailVC: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate {
    
    weak var delegatePassInfoOneCustomer: PassInfoOneCustomerDelegateProtocol?
    weak var delegatePassImage: PassImageDelegateProtocol?
    
    //    weak var delegatePassInfoCustomer: PassInfoCustomer?
    
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
    
    var dataInfoOneCustomer: Location = Location(elem: LocationElement(arrivalTime: ArrivalTime(),location: LocationLocation(), locationOrder: 0 ), asset: GetAsset(assetModelID: 0, properties: PropertiesDetail(updatedAt: "", values: ValuesDetail(customer_location: [], kyokyusetsubi_code: ""))), createdAt: "")
    
    @IBOutlet weak var viewContainerScrollview: UIScrollView!
    
    @IBOutlet weak var stackViewContainer: UIStackView!
    
    @IBOutlet weak var lblCustomer_id: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!

    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var viewLBLType: UIView!
    @IBOutlet weak var lblType: UIView!
    @IBOutlet weak var lblNumber: UIView!
    @IBOutlet weak var viewLBLNumber: UIView!
    @IBOutlet weak var stackViewType: UIStackView!
        
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var lblTextNotes: UITextView!
    
    @IBOutlet weak var viewInfoAstimate: UIView!
    @IBOutlet weak var viewContain2Label: UIView!
    @IBOutlet weak var lblEstimateDeliveryDate: UILabel!
    @IBOutlet weak var lblEstimateDelivery: UILabel!

    
    @IBAction func btnEdit(_ sender: Any) {
        let screenEdit = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        self.navigationController?.pushViewController(screenEdit, animated: true)
    }
    
    @IBAction func pageControlDidPage(_ sender: Any) {
        
    }
    
    @IBAction func btnOpenMap(_ sender: Any) {
        
        //        let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTextNotes.isEditable = false
        
        
        //        let layout = UICollectionViewLayout()
        //        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //        collectionView = UICollectionView(frame: .zero)
        
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
        var listUrlImage: [String] = []
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
            
            listUrlImage.append(gasLocation1)
            listUrlImage.append(gasLocation2)
            listUrlImage.append(gasLocation3)
            listUrlImage.append(gasLocation4)
            listUrlImage.append(parkingPlace5)
            listUrlImage.append(parkingPlace6)
            listUrlImage.append(parkingPlace7)
            listUrlImage.append(parkingPlace8)
            
        }
        
        delegatePassImage?.passUrlImage(urlImage: listUrlImage)
        
        
        if dataInfoOneCustomer.type == .supplier {
            lblCustomer_id?.text = comment
            lblCustomerName.removeFromSuperview()
            lblAddress.removeFromSuperview()
            lblDeliveryTime.removeFromSuperview()
            lblEstimateDelivery.removeFromSuperview()
            lblEstimateDeliveryDate.removeFromSuperview()
            collectionView.removeFromSuperview()
            viewImage.removeFromSuperview()
            viewNote.removeFromSuperview()
            viewType.removeFromSuperview()
            lblTextNotes.removeFromSuperview()
            viewContain2Label.removeFromSuperview()
            
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
            if arrImage.isEmpty {  // delete View if not Image
                stackViewContainer.removeArrangedSubview(viewImage)
                viewImage.removeFromSuperview()
            }
            arrFacilityData.append(dataInfoOneCustomer.elem?.metadata?.facility_data ?? [])
            viewLBLType.layer.cornerRadius = 9
            lblType.layer.cornerRadius = 9
            lblType.layer.masksToBounds = true
            
            viewLBLNumber.layer.cornerRadius = 9
            lblNumber.layer.cornerRadius = 9
            lblNumber.layer.masksToBounds = true
            
       
            for iFacilityData in arrFacilityData {
                for iFacilityDataDetail in iFacilityData {
                    let typeView = ReuseViewType(frame: self.stackViewType.bounds)
                    typeView.loadInfoViewType(iFacilityDataDetail: iFacilityDataDetail)
                    
                    stackViewType.addArrangedSubview(typeView)
                }
                
            }
            
            if dataInfoOneCustomer.asset?.properties?.values.notes != "" {
                lblTextNotes.text = dataInfoOneCustomer.asset?.properties?.values.notes
                
                
                self.lblTextNotes.translatesAutoresizingMaskIntoConstraints = false
                lblTextNotes.isScrollEnabled = false
            } else {
                lblTextNotes.text = " Hiển thị ra cho có, khi Notes không có cái gì"
            }
            
            lblEstimateDelivery?.text = dataInfoOneCustomer.elem?.metadata?.planned_date
            viewContain2Label.layer.cornerRadius = 6
            viewContain2Label.layer.masksToBounds = true
//            lblEstimateDeliveryDate.layer.cornerRadius = 10
//            lblEstimateDeliveryDate.layer.masksToBounds = true
            lblEstimateDelivery.layer.cornerRadius = 4
//            viewInfoAstimate.layer.cornerRadius = 10
            
//            viewInfoAstimate.layer.masksToBounds = true
            
            var arrDataUrlImage = [String]()
            
            for iUrlImage in arrImage where iUrlImage != "" {
                arrDataUrlImage.append(iUrlImage)
            }
            
            arrImage = arrDataUrlImage
        }
        
        
        //        guard let deliveryVC = storyboard?.instantiateViewController(withIdentifier: "DeliveryListController") as? DeliveryListController  else { return }
        //        delegatePassInfoCustomer = deliveryVC
        //
        //        print(dataInfoOneCustomer.asset?.id)
        //
        //        print(dataInfoOneCustomer.asset?.name)
        //        print(dataInfoOneCustomer.asset?.properties?.values.customer_name)
        //        delegatePassInfoCustomer?.passInfoCustomerShipping(infoCustomer: dataInfoOneCustomer )
        
    }
    
    
    
    func scrollViewDidEndDecelerating(scrollImage: UIScrollView) {
        pageControl.currentPage = Int(viewContainerScrollview.contentOffset.x / viewContainerScrollview.bounds.width)
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

extension PageDetailVC: UICollectionViewDelegateFlowLayout {  // resize cho item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize.init(width: screenWidth, height: 250 )
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
        let cellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PageDetailCollectionViewCell
        
        if !arrImage.isEmpty {
            let iurl = arrImage[indexPath.row]
            
            // Alamofire
            AF.request(iurl, method: .get).response { response in
                switch response.result {
                case .success(let responseData):
                    cellImage.imgImage.image = UIImage(data: responseData!)
                case .failure(let error):
                    print("error--->",error)
                }
            }
        }
        
        cellImage.layer.shouldRasterize = true
        return cellImage
    }
}

