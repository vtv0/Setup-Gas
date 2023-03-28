//
//  ViewCollection.swift
//  Gas
//
//  Created by Vuong The Vu on 17/03/2023.
//

import UIKit
import Alamofire
import AlamofireImage

enum SectionImage: Int, CaseIterable {
    case hasImage = 1
    case notImage = 0
}

class SectionIndex: Hashable {
    let index: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
    static func == (lhs: SectionIndex, rhs: SectionIndex) -> Bool {
        lhs.index == rhs.index
    }
    init(index: Int) {
        self.index = index
    }
}

class ViewCollection: UIViewController {
    
    var locationsIsCustomer: [Location] = []
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    var imageSource: UICollectionViewDiffableDataSource< SectionImage, [String]>! = nil
    
    var dataSource: UICollectionViewDiffableDataSource<SectionIndex, Location>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.collectionViewLayout = createLayout()
        configImageSource()
        //configureDataSource()
       
    }
    
    func configImageSource() {
        imageSource = UICollectionViewDiffableDataSource<SectionImage, [String]> (collectionView: myCollectionView) {
            (collectionView: UICollectionView, indexpathImage: IndexPath, urls: [String]) -> UICollectionViewCell? in
            guard let cellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexpathImage) as? CellImage else { fatalError("Cannot create new cell") }
            cellImage.imgImageCollectionCell.loadImageDBorAPI(iurl: "https://52nbhwgyk0am.jp.kiiapps.com/api/x/s.11a4516c68e0-e849-de11-f532-55b150b5")
            return cellImage
        }
            
        var snapshotImage = NSDiffableDataSourceSnapshot<SectionImage, [String]>()
        for (ind, ilocation) in locationsIsCustomer.enumerated() {
            snapshotImage.appendSections([.notImage])
            snapshotImage.appendItems([ilocation.urls()])
            snapshotImage.appendSections([.hasImage])
            snapshotImage.appendItems([ilocation.urls()])
            
        }
        imageSource.apply(snapshotImage)
        
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionIndex, Location>(collectionView: myCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, ilocation: Location) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",for: indexPath) as? CollectionViewCell else { fatalError("Cannot create new cell") }
            
            cell.lblAssetID.text = ilocation.elem?.metadata?.customer_id
            cell.lblName.text = ilocation.asset?.properties?.values.customer_name
            cell.lblAddress.text = ilocation.asset?.properties?.values.address
            if let minutes = ilocation.elem?.arrivalTime?.minutes,
               let hours = ilocation.elem?.arrivalTime?.hours {
                if minutes < 10 {
                    cell.lblEstimateTime?.text = "Estimate Time : \(hours):0\(minutes)"
                } else {
                    cell.lblEstimateTime?.text = "Estimate Time : \(hours):\(minutes)"
                }
            }
            
            return cell
            
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<SectionIndex, Location>()
        for (ind, ilocation) in locationsIsCustomer.enumerated() {
            snapshot.appendSections([.init(index: ind)])
            snapshot.appendItems([ilocation])
        }
        dataSource.apply(snapshot)
        
        
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
            
            let infoItem = self.listLayout()
            let imageGroup = self.imageLayout()
            
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(200)),
                subitems: [imageGroup, infoItem])
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
    
    func listLayout() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(110))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
//        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(12), trailing: nil, bottom: .fixed(12))
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .estimated(110))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        // let layout = UICollectionViewCompositionalLayout(section: section)
        return item
    }
    
    func imageLayout() -> NSCollectionLayoutGroup {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(110))
        let itemImage = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [itemImage])
        
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
//        section.interGroupSpacing = 10
//        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
//        section.supplementariesFollowContentInsets = false
        //        let layout = UICollectionViewCompositionalLayout(section: section)
        return group
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
//extension ViewCollection: UICollectionViewDelegateFlowLayout {
//    func textHeight(font: UIFont, text: String) -> CGFloat {
//        let myText = text as NSString
//        let rect = CGSize(width: self.myCollectionView.frame.width, height: CGFloat.greatestFiniteMagnitude)
//        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//        return ceil(labelSize.height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let text = locationsIsCustomer[indexPath.row].asset?.properties?.values.customer_name ?? ""
//        let heightName = textHeight(font: .systemFont(ofSize: 17.0), text: text)
//        let assetID = textHeight(font: .systemFont(ofSize: 17.0), text: locationsIsCustomer[indexPath.row].elem?.location?.assetID ?? "")
//        let address = textHeight(font: .systemFont(ofSize: 17.0), text: locationsIsCustomer[indexPath.row].asset?.properties?.values.address ?? "")
//        let time = textHeight(font: .systemFont(ofSize: 17.0), text: "\(locationsIsCustomer[indexPath.row].elem?.arrivalTime?.hours ?? 0)")
//        return CGSize(width: self.myCollectionView.frame.width, height: heightName + assetID + address + time )
//    }
//}


