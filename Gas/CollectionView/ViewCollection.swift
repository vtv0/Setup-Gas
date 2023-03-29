//
//  ViewCollection.swift
//  Gas
//
//  Created by Vuong The Vu on 17/03/2023.
//

import UIKit
import Alamofire
import AlamofireImage

//enum SectionImage: Int, CaseIterable {
//    case hasImage = 1
//    case notImage = 0
//}

class SectionIndex: Hashable {
    let index: Int
    
    init(index: Int) {
        self.index = index
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
    static func == (lhs: SectionIndex, rhs: SectionIndex) -> Bool {
        lhs.index == rhs.index
    }
    
}

class ViewCollection: UIViewController {
    
    var locationsIsCustomer: [Location] = []
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    //    var imageSource: UICollectionViewDiffableDataSource< SectionIndex, Int>! = nil
    
    var dataSource: UICollectionViewDiffableDataSource<SectionIndex, Int>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.collectionViewLayout = createLayout()
        
        configureDataSource()
        
    }
    
    //    func configImageSource() {
    //        imageSource = UICollectionViewDiffableDataSource<SectionIndex, Int> (collectionView: myCollectionView) {
    //            (collectionView: UICollectionView, indexpathImage: IndexPath, int: Int) -> UICollectionViewCell? in
    //            guard let cellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexpathImage) as? CellImage else { fatalError("Cannot create new cell") }
    //            cellImage.imgImageCollectionCell.loadImageDBorAPI(iurl: "https://52nbhwgyk0am.jp.kiiapps.com/api/x/s.11a4516c68e0-e849-de11-f532-55b150b5")
    //            return cellImage
    //        }
    //
    //        var snapshotImage = NSDiffableDataSourceSnapshot<SectionIndex, Int>()
    //        for (ind, _) in locationsIsCustomer.enumerated() {
    ////            snapshotImage.appendSections([.notImage])
    //
    //            snapshotImage.appendSections([.init(index: ind)])
    //            snapshotImage.appendItems( [0,2,3,4,5,6,7,8,9] )
    ////            for i in ilocation.urls() {
    ////                snapshotImage.appendItems([i])
    ////            }
    //
    //
    //        }
    //        imageSource.apply(snapshotImage)
    //
    //    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionIndex, Int>(collectionView: myCollectionView) { [self]
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            print(indexPath.section)
        
            switch indexPath.section % 2 == 0 {
            case true:
            
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",for: indexPath) as? CollectionViewCell else { fatalError("Cannot create new cell") }
                cell.backgroundColor = .cyan
                
                cell.lblAssetID.text = locationsIsCustomer[indexPath.section].elem?.metadata?.customer_id
                //
//                cell.lblName.text = ilocation.asset?.properties?.values.customer_name
//                                cell.lblAddress.text = ilocation.asset?.properties?.values.address
//                                if let minutes = ilocation.elem?.arrivalTime?.minutes,
//                                   let hours = ilocation.elem?.arrivalTime?.hours {
//                                    if minutes < 10 {
//                                        cell.lblEstimateTime?.text = "Estimate Time : \(hours):0\(minutes)"
//                                    } else {
//                                        cell.lblEstimateTime?.text = "Estimate Time : \(hours):\(minutes)"
//                                    }
//                                }
                return cell
                
            case false:
                guard let cellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexPath) as? CellImage else { fatalError("Cannot create new cell") }
                cellImage.backgroundColor = .yellow
//                let urls = locationsIsCustomer[indexPath.section].urls()
//                for i in urls {
//                    cellImage.imgImageCollectionCell.loadImageDBorAPI(iurl: i )
//                }
                return cellImage
            }
           
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<SectionIndex, Int>()
       
        locationsIsCustomer.enumerated() .forEach { ind, ilocation in
 
            snapshot.appendSections([SectionIndex(index: ind * 2)])
            snapshot.appendItems([ind])
           
            
            snapshot.appendSections([SectionIndex(index: ind * 2 + 1 )])
            for (indImage, _) in ilocation.urls().enumerated() {
                snapshot.appendItems([indImage])
            }
            
        }
        dataSource?.apply(snapshot)
        
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [self]  ind, env -> NSCollectionLayoutSection? in
          //  //print(sectionNumber.)
            switch ind % 2 == 0 {
            case true:
                return listLayout()
                
            case false:
                return imageLayout()
            }
        }
    }
    
    func listLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(12), trailing: nil, bottom: .fixed(12))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(110))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
//                 let layout = UICollectionViewCompositionalLayout(section: section)
        return section
    }
    
    func imageLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0) )
        let itemImage = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(130))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [itemImage])
        
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        //        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.supplementariesFollowContentInsets = false
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
//                let layout = UICollectionViewCompositionalLayout(section: section)
        return section
        
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


