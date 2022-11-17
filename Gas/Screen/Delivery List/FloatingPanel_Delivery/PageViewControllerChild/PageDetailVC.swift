//
//  PageFristVC.swift
//  Gas
//
//  Created by Vuong The Vu on 05/10/2022.
//

import UIKit
import Alamofire
import FloatingPanel

protocol ShowSelectedMarkerDelegate {
    func ShowSelectedMarker()
}

class PageDetailVC: UIViewController , UIScrollViewDelegate, UICollectionViewDelegate {
    
    var pageIndex: Int!
    var customer_id: String = ""
    var planned_date: String = ""
    var arrivalTime_hours: Int = 0
    var arrivalTime_minutes: Int = 0
    var customer_name: String = ""
    var customer_address: String = ""
    var arrNotes: String = ""
    
    var typeGas: Int = 0
    var numberGas: Int = 0
    
    var image: [String] = ["", "0", "1","2","camel", "dog"]
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblCustomer_id: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    
    @IBOutlet weak var lblAstimateDelivery: UILabel!
    
    @IBOutlet weak var lblTypeGas: UILabel!
    @IBOutlet weak var lblNumberGas: UILabel!
    @IBOutlet weak var stackViewShowInfoGas: UIStackView!
    @IBOutlet weak var lblTextNotes: UITextView!
    
    @IBOutlet weak var viewImageScroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
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
        pageControl.numberOfPages = image.count
        
        lblCustomer_id?.text = customer_id
        lblCustomerName?.text = customer_name
        lblAddress?.text = customer_address
        lblDeliveryTime?.text = "Estimate Time : \(arrivalTime_hours):\(arrivalTime_minutes)"
        lblTypeGas?.text = "\(typeGas)kg"
        lblNumberGas?.text = "\(numberGas)bottle"
        
        if arrNotes.isEmpty {
            lblTextNotes.text = " Hiển thị ra cho có khi Notes không có cái gì"
        } else {
            lblTextNotes.text = arrNotes
        }
        lblAstimateDelivery?.text = planned_date
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


extension PageDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = image.count
        pageControl.numberOfPages = count
        pageControl.isHidden = !(count > 1)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  as? PageDetailCollectionViewCell
        cell?.imgImage.image = UIImage(named: image[indexPath.row] )
        return cell!
    }
    
    
}
