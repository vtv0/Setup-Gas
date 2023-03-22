//
//  ViewCollection.swift
//  Gas
//
//  Created by Vuong The Vu on 17/03/2023.
//

import UIKit

class ViewCollection: UIViewController {
    
    var locationsIsCustomer: [Location] = []
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.dataSource = self
        //        myCollectionView.delegate = self
        
        myCollectionView.collectionViewLayout = listSection()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let itemImage = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(70),
                                               heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [itemImage])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.supplementariesFollowContentInsets = false
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func listSection() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(110))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    func textHeight(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        let rect = CGSize(width: self.myCollectionView.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.height)
    }
}

extension ViewCollection: UICollectionViewDataSource {
    
    // UICollectionViewDelegateFlowLayout
    //        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //            let text = locationsIsCustomer[indexPath.row].asset?.properties?.values.customer_name ?? ""
    //
    //            let heightName = textHeight(font: .systemFont(ofSize: 17.0), text: text)
    //            let assetID = textHeight(font: .systemFont(ofSize: 17.0), text: locationsIsCustomer[indexPath.row].elem?.location?.assetID ?? "")
    //            let address = textHeight(font: .systemFont(ofSize: 17.0), text: locationsIsCustomer[indexPath.row].asset?.properties?.values.address ?? "")
    //            let time = textHeight(font: .systemFont(ofSize: 17.0), text: "\(locationsIsCustomer[indexPath.row].elem?.arrivalTime?.hours ?? 0)")
    //            return CGSize(width: self.myCollectionView.frame.width, height: heightName + assetID + address + time )
    //        }
    
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationsIsCustomer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as? CollectionViewCell else {  return UICollectionViewCell() }
        cell.lblAssetID.text = locationsIsCustomer[indexPath.row].elem?.metadata?.customer_id
        cell.lblName.text = locationsIsCustomer[indexPath.row].asset?.properties?.values.customer_name
        cell.lblAddress.text = locationsIsCustomer[indexPath.row].asset?.properties?.values.address
        
        if let minutes = locationsIsCustomer[indexPath.row].elem?.arrivalTime?.minutes,
           let hours = locationsIsCustomer[indexPath.row].elem?.arrivalTime?.hours {
            if minutes < 10 {
                cell.lblEstimateTime?.text = "Estimate Time : \(hours):0\(minutes)"
            } else {
                cell.lblEstimateTime?.text = "Estimate Time : \(hours):\(minutes)"
            }
        }
        return cell
        
    }
}


extension ViewCollection {
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, <#ItemIdentifierType: Hashable & Sendable#>> {
        
    }
}
