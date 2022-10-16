//
//  PageFristVC.swift
//  Gas
//
//  Created by Vuong The Vu on 05/10/2022.
//

import UIKit

class PageDetailVC: UIViewController , UIScrollViewDelegate, UICollectionViewDelegate {
    
    var pageIndex: Int!
    var content: String = ""
    
    var thisWidth:CGFloat = 0
    
    var image:[String] = ["0", "1","2","camel", "dog"]
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
        }
    }
    
//    @IBOutlet weak var scrollImage: UIScrollView!
//
    
    @IBOutlet weak var viewImageScroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblContent: UILabel!
    @IBAction func btnEdit(_ sender: Any) {
        print("click Edit")
        let screenEdit = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        self.navigationController?.pushViewController(screenEdit, animated: true)
    }
    
    @IBAction func pageControlDidPage(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = image.count
       // self.pageControl.numberOfPages = pageControl.count
        
    }
    func scrollViewDidEndDecelerating(scrollImage: UIScrollView) {
//        pageControl.currentPage = Int(scrollImage.contentOffset.x / scrollImage.bounds.width)
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
