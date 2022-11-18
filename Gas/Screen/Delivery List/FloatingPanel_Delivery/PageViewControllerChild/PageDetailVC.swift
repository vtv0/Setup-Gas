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
    var planned_date: String = ""
    var arrivalTime_hours: Int = 0
    var arrivalTime_minutes: Int = 0
    var customer_name: String = ""
    var customer_address: String = ""
    var arrNotes: String = ""
    
    var typeGas: Int = 0
    var numberGas: Int = 0
    
    var arrUrlImage: [String] = []// ["0", "1","2","camel", "dog"]
    
    
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
        collectionView.dataSource = self
        pageControl.numberOfPages = arrUrlImage.count
        
        lblCustomer_id?.text = customer_id
        lblCustomerName?.text = customer_name
        lblAddress?.text = customer_address
        lblDeliveryTime?.text = "Estimate Time : \(arrivalTime_hours):\(arrivalTime_minutes)"
        //collectionView.
        lblTypeGas?.text = "\(typeGas)kg"
        lblNumberGas?.text = "\(numberGas)bottle"
        
        if arrNotes.isEmpty {
            lblTextNotes.text = " Hiển thị ra cho có khi Notes không có cái gì"
        } else {
            lblTextNotes.text = arrNotes
        }
        lblAstimateDelivery?.text = planned_date
        
        var arrDataUrlImage = [String]()
        for iUrlImage in arrUrlImage where iUrlImage != "" {
            arrDataUrlImage.append(iUrlImage)
        }
        arrUrlImage = arrDataUrlImage
        print(arrDataUrlImage.count)
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
    
    //    func getImage() {
    //        for i in arrUrlImage {
    //            Alamofire.request("\(i)").responseImage { response in
    //                if let catPicture = response.result.value {
    //                    print("image downloaded: \(image)")
    //                }
    //            }
    //        }
    //
    //    }
    
    
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
        let count = arrUrlImage.count
        pageControl.numberOfPages = count
        pageControl.isHidden = !(count > 1)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  as? PageDetailCollectionViewCell
        cell?.imgImage.image = UIImage(named: arrUrlImage[indexPath.row])
        
        
        //cell?.imgImage.loadFrom(URLAddress: "https://52nbhwgyk0am.jp.kiiapps.com/api/x/s.7b83d7a00022-2ed9-ce11-ed1f-a4067c05")
        //        for i in arrUrlImage {
        //            let url = URL(string: "\(i)")!
        
//        if let data = try? Data(contentsOf: URL(string: "https://52nbhwgyk0am.jp.kiiapps.com/api/x/s.7b83d7a00022-2ed9-ce11-ed1f-a4067c05")! ) {
//            cell?.imgImage.image = UIImage(data: data)
//
//        }
        
        
        //        }
        
        
        return cell!
    }
    
    
}

