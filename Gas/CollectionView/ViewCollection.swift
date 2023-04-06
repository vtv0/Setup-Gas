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


class SizeImage {
    var url: String? = ""
    var width: CGFloat? = 1.0
    var height: CGFloat? = 1.0
    
    init(url: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.url = url
        self.width = width
        self.height = height
    }
    
}

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
    
    //    var modelImage: [Int: [SizeImage]]  = [:]
    
    var modelImage: [Int: Location]  = [:]
    var dicRatio: [String: CGFloat] = [:]
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    //    var imageSource: UICollectionViewDiffableDataSource< SectionIndex, Int>! = nil
    
    var dataSource: UICollectionViewDiffableDataSource<SectionIndex, String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.collectionViewLayout = createLayout()
        configureDataSource()
        myCollectionView.reloadData()
        
        
        
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionIndex, String>(collectionView: myCollectionView) { [self]
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            switch indexPath.section % 2 == 0 {
            case true:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",for: indexPath) as? CollectionViewCell else { fatalError("Cannot create new cell") }
                
                let ilocation = self.locationsIsCustomer[indexPath.section / 2]
                
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
                
                cell.lblAssetID.text = identifier
                
                return cell
                
            case false:
                
                guard let cellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexPath) as? CellImage else { fatalError("Cannot create new cell") }
                
                cellImage.imgImageCollectionCell.loadImageDBorAPI(iurl: identifier) {
                    
                    
                    var ratio: CGFloat = 1.0
                    
                    if let width = cellImage.widthImage(), let height = cellImage.heightImage() {
                        ratio = width / height
                    }
                    
                    self.dicRatio[identifier] = ratio
                    
                    //                    self.dataSource?.replaceItems(["CellImage"], in: SectionIndex(index: indexPath.item))
//                    DispatchQueue.main.async {
//                        self.dataSource?.replaceItems(section: SectionIndex.init(index: indexPath.section), items: [identifier])
                        self.myCollectionView.collectionViewLayout.invalidateLayout()
//                    }
                }
                
                //
                //                if let image = self.dataSource?.itemIdentifier(for: indexPath) {
                //                   var image = image
                //
                //                    var snap = self.dataSource?.snapshot()
                //                    snap?.reloadItems([identifier])
                //                   self.dataSource?.apply(snap!)
                //                }
                
                return cellImage
            }
            
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<SectionIndex, String>()
        
        locationsIsCustomer.enumerated().forEach { ind, ilocation in
            
            snapshot.appendSections([SectionIndex(index: ind * 2)])
            
            snapshot.appendItems([(ilocation.elem?.metadata?.customer_id)! ])
            
            snapshot.appendSections([SectionIndex(index: ind * 2 + 1 )])
            for (_, iurl) in ilocation.urls().enumerated() {
                if ilocation.urls().isEmpty {
                    print("Not Image")
                    snapshot.deleteSections([SectionIndex(index: ind * 2 + 1 )])
                } else {
                    snapshot.appendItems([iurl])
                }
            }
        }
        
        dataSource?.apply(snapshot)
        
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [self] indSection, env -> NSCollectionLayoutSection? in
            switch indSection % 2 == 0 {
            case true:
                return listLayout()  // 0,2,4,6,8
            case false:
                let ilocation = locationsIsCustomer[indSection / 2]
                if ilocation.urls().isEmpty {
                    return listLayout()
                } else {
                    modelImage[indSection] = ilocation
                    return imageLayout(indexSection: indSection)  //1,3,5,7
                    
                }
            }
        }
        
    }
    
    func listLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(12), trailing: nil, bottom: .fixed(12))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(110))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        //                 let layout = UICollectionViewCompositionalLayout(section: section)
        return section
    }
    
    
    func imageLayout(indexSection: Int) -> NSCollectionLayoutSection {
        var itemImages: [NSCollectionLayoutItem] = []
        
        let ilocation = modelImage[indexSection]
        let arrImage = ilocation?.urls()
        if arrImage?.count == 0 {
            let iImageItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(0), heightDimension: .absolute(150) ))
            itemImages.append(iImageItem)
            
        } else {
            for iurl in arrImage!{
                var ratio: CGFloat = 0.0
                ratio = dicRatio[iurl] ?? 0.0
                let iImageItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(150 * ratio), heightDimension: .absolute(150) ))
                itemImages.append(iImageItem)
                
            }
            
        }
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(150),
                                               heightDimension: .absolute(150))
        let imageGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: itemImages)
        imageGroup.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: imageGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.supplementariesFollowContentInsets = false
        return section
        
    }
    
}



extension UICollectionViewDiffableDataSource {
    
    func replaceItems(section: SectionIdentifierType , items : [ItemIdentifierType]) {
        var currentSnapshot = snapshot()
//                let itemsOfSection = currentSnapshot.itemIdentifiers(inSection: section)
//                currentSnapshot.deleteItems(itemsOfSection)
//        
//                currentSnapshot.appendItems(items, toSection: section)
                currentSnapshot.reloadSections([section])
//        currentSnapshot.reloadItems(items)
        apply(currentSnapshot, animatingDifferences: true)
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


