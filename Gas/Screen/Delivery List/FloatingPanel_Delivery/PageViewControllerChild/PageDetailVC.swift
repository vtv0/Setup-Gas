//
//  PageFristVC.swift
//  Gas
//
//  Created by Vuong The Vu on 05/10/2022.
//

import UIKit
import Alamofire
import FloatingPanel

class PageDetailVC: UIViewController , UIScrollViewDelegate, UICollectionViewDelegate {
    
    var pageIndex: Int!
    var content: String = ""
    
    var thisWidth: CGFloat = 0
    
    var image: [String] = ["0", "1","2","camel", "dog"]
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblCustomer_id: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    
    
    @IBOutlet weak var viewImageScroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    
    @IBAction func btnEdit(_ sender: Any) {
        print("click Edit")
        let screenEdit = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        self.navigationController?.pushViewController(screenEdit, animated: true)
    }
    
    @IBAction func pageControlDidPage(_ sender: Any) {
        
    }
    
    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
    let tenantId = UserDefaults.standard.string(forKey: "tenantId") ?? ""
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    var arrCustommerID: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrCustommerID =  UserDefaults.standard.stringArray(forKey: "ArrCustomerID") ?? []
    //    print(arrCustommerID)
        
        collectionView.delegate = self
        pageControl.numberOfPages = image.count
        
       showLblInfomation()
        // self.sevenDay()
        //getLatestWorkerRouteLocationList()
    }
    
    func showLblInfomation() {
       
         lblCustomer_id.text = arrCustommerID[0]
        
    }
    
    var dateYMD: [Date] = []
    func sevenDay() {
        // 7 ngay
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                dateYMD.append(date1)
            }
        }
    }
    
    func makeHeaders(token: String) -> HTTPHeaders {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Bearer " + token
        return HTTPHeaders(headers)
    }
    var dicData: [Date : [LocationElement]] = [:]
    var locations: [LocationElement] = []
    var t: Int = 0
    var totalObjectSevenDate: Int = 0
    func  getLatestWorkerRouteLocationList() {
        self.showActivity()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        for iday in dateYMD {
            let dateString: String = formatter.string(from: iday)
            let url: String = "https://\(companyCode).kiiapps.com/am/exapi/vrp/tenants/\(tenantId)/latest_route/worker_users/\(userId)?workDate=\(dateString)"
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.makeHeaders(token: token)).validate(statusCode: (200...299))
                .responseDecodable(of: GetLatestWorkerRouteLocationListInfo.self) { response in
                    print("\(url)::::>\( response.response?.statusCode ?? 0)")
                    
                    self.t += 1
                    
                    switch response.result {
                    case .success(_):
                        let countObject = response.value?.locations?.count
                        self.locations = response.value?.locations ?? []
                        
                        
                        if countObject != 0 {
                            var locations: [LocationElement] = []
                            for itemObject in self.locations {
                                locations.append(itemObject)
                                self.totalObjectSevenDate += 1
                                if itemObject.location?.assetID != nil {
                                    self.getGetAsset(forAsset: (itemObject.location!.assetID)!, locationOrder: itemObject.locationOrder )
                                } else {
                                    print("Khong co assetID-> Supplier")
                                }
                            }
                            
                            
                            self.dicData[iday] = locations
                            
                        } else {
                            print(response.response?.statusCode as Any)
                            print("\(url) =>> Array Empty, No Object ")
                        }
                        
                    case .failure(let error):
                        
                        print("Error: \(response.response?.statusCode ?? 000000)")
                        print("Error: \(error)")
                    }
                    if self.t == self.dateYMD.count {
                        self.hideActivity()
                        
                    }
                }
        }
        
    }
    
    
    
    func getGetAsset(forAsset iassetID: String, locationOrder: Int) {
        
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let urlGetAsset = "https://\(companyCode).kiiapps.com/am/api/assets/\(iassetID)"
        AF.request(urlGetAsset,method: .get, parameters: nil, headers: self.makeHeaders(token: token))
            .responseDecodable(of: GetAsset.self ) { response1 in
                switch response1.result {
                case .success:
                    
                    
                    if self.totalObjectSevenDate == self.totalObjectSevenDate {
                        self.hideActivity()
                    }
                    
                case .failure(let error):
                    print("\(error)")
                }
            }
        
    }
    
    func scrollViewDidEndDecelerating(scrollImage: UIScrollView) {
        pageControl.currentPage = Int(scrollImage.contentOffset.x / scrollImage.bounds.width)
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
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
        
        // return image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  as? PageDetailCollectionViewCell
        cell?.imgImage.image = UIImage(named: image[indexPath.row] )
        //cell?.imgImage.image = UIImage(named: "P")
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl?.currentPage = Int(roundedIndex)
    }
}
