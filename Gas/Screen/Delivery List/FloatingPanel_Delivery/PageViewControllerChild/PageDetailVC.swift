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



class PageDetailVC: UIViewController , UIScrollViewDelegate, UICollectionViewDelegate {
    
    var pageIndex: Int!
    var customer_id: String = ""
    var arrUrlImage: [[String]] = []
    
    var dateYMD: [Date] = []
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    var dicData: [Date : [LocationElement]] = [:]
    var locations: [LocationElement] = []
    var t: Int = 0
    var totalObjectSevenDate: Int = 0
    var arrCustomer_id: [String] = []
    var data: [String] = []
    var arrFacilityData = [[Facility_data]]()
    
    var arrImage = [String]()
    var dataInfoOneCustomer: Location = Location(elem: LocationElement(locationOrder: 0), asset: GetAsset(assetModelID: 0, enabled: true))
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblCustomer_id: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    
    @IBOutlet weak var lblAstimateDelivery: UILabel!
    
    @IBOutlet weak var lblTypeGas: UILabel!
    @IBOutlet weak var lblNumberGas: UILabel!
    @IBOutlet weak var lblTypeGasInStackView: UILabel!
    @IBOutlet weak var lblNumberGasInStackView: UILabel!
    
    @IBOutlet weak var stackViewShowInfoGas: UIStackView!
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
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.numberOfPages = arrImage.count
        
        
        if dataInfoOneCustomer.type == .supplier {
            lblCustomer_id?.text = customer_id
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
            //    print(dataInfoOneCustomer)
            lblCustomer_id?.text = dataInfoOneCustomer.elem?.location?.comment
            lblCustomerName?.text = dataInfoOneCustomer.asset?.properties?.values.customer_name
            
            lblAddress?.text = dataInfoOneCustomer.asset?.properties?.values.address
            
            lblDeliveryTime?.text = "Estimate Time : \(dataInfoOneCustomer.elem?.arrivalTime?.hours ?? 00):\(dataInfoOneCustomer.elem?.arrivalTime?.minutes ?? 0)"
            
            
            arrImage.removeAll()
            if let gasLocation1 = dataInfoOneCustomer.asset?.properties?.values.gas_location1, let gasLocation2 = dataInfoOneCustomer.asset?.properties?.values.gas_location2 , let gasLocation3 = dataInfoOneCustomer.asset?.properties?.values.gas_location3, let gasLocation4 = dataInfoOneCustomer.asset?.properties?.values.gas_location4 , let parkingPlace1 = dataInfoOneCustomer.asset?.properties?.values.parking_place1, let parkingPlace2 = dataInfoOneCustomer.asset?.properties?.values.parking_place2, let parkingPlace3 = dataInfoOneCustomer.asset?.properties?.values.parking_place3, let parkingPlace4 = dataInfoOneCustomer.asset?.properties?.values.parking_place4 {
                
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
            
            
            for iFacilityData in  arrFacilityData {
                if iFacilityData.count == 1 {
                    lblTypeGas?.text = "\(iFacilityData[0].type ?? 0 )kg"
                    lblNumberGas?.text = "\(iFacilityData[0].count  ?? 0)bottle"
                    stackViewShowInfoGas.removeFromSuperview()
                    
                } else if iFacilityData.count > 1 {
                    self.view.addSubview(stackViewShowInfoGas)
                    stackViewShowInfoGas.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        stackViewShowInfoGas.bottomAnchor.constraint(equalTo: viewDetail.bottomAnchor),
                        stackViewShowInfoGas.leftAnchor.constraint(equalTo: viewDetail.leftAnchor, constant: 40),
                        stackViewShowInfoGas.rightAnchor.constraint(equalTo: viewDetail.rightAnchor, constant: -40),
                        stackViewShowInfoGas.heightAnchor.constraint(equalToConstant: 30)
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
        //pageControl.currentPage = Int(viewImageScroll.contentOffset.x / viewImageScroll.bounds.width)
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
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

extension UIImageView {
    
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
    
}

extension PageDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = arrImage.count
        pageControl.numberOfPages = count
        pageControl.isHidden = !(count > 1)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  as? PageDetailCollectionViewCell
        if !arrImage.isEmpty {
            let iurl = arrImage[indexPath.row]
            if let data = try? Data(contentsOf: URL(string: "\(iurl)")! ) {
                cell?.imgImage.image = UIImage(data: data)
                
            }
        }
        
        return cell!
    }
    
    
}

