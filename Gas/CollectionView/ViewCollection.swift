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
    
    var modelImage: [Int: [SizeImage]]  = [:]
    
    //    var modelImage: [Location]  = []
    
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    //    var imageSource: UICollectionViewDiffableDataSource< SectionIndex, Int>! = nil
    
    var dataSource: UICollectionViewDiffableDataSource<SectionIndex, String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        
        myCollectionView.collectionViewLayout = createLayout()
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
                
                var arrSizeImage = [SizeImage]()
                guard let cellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexPath) as? CellImage else { fatalError("Cannot create new cell") }
                
                cellImage.imgImageCollectionCell.loadImageDBorAPI(iurl: identifier) { [self] in
                    
                    if let height = cellImage.heightImage(),
                       let width = cellImage.widthImage() {
                        
                        let sizeImage: SizeImage = SizeImage(url: identifier, width: width, height: height)
                        let key = (indexPath.section)
                        //                        print(key)
                        
                        for iImage in arrSizeImage where iImage.url != identifier {
                            arrSizeImage.append(sizeImage)
                        }
                        modelImage[key] = arrSizeImage
                        
//                        modelImage.updateValue([sizeImage], forKey: key)
                        
                    }
                }
                myCollectionView.collectionViewLayout.invalidateLayout()
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
                    //                    snapshot.deleteSections([SectionIndex(index: ind * 2 + 1 )])
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
        
        
        //        let itemImage2 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(150) ))
        //        let itemImage3 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(150) ))
        
        
        //
        var itemImages: [NSCollectionLayoutItem] = []
        
        var arrImage: [SizeImage] = []
        arrImage = modelImage[indexSection] ?? []
        
        //        modelImage[indexSection]
        if arrImage.isEmpty {
            print(" khong co anh trong ::> modelImage ")
            
            let iImageItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(1), heightDimension: .absolute(150) ))
            itemImages.append(iImageItem)
            
            
        } else {
            print("indSection:\(indexSection) co: \(arrImage.count)")
            for (ind, image) in arrImage.enumerated() {
                var ratio: CGFloat = 0.0
                if let height = image.height, let width = image.width {
                    ratio = width / height
                    
                    
                    
                    print("\(ind) -> (\(width) / \(height)) = \(ratio)")
                    
                    
                    let iImageItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(150 * ratio), heightDimension: .absolute(150) ))
                    itemImages.append(iImageItem)
                    
                } else {
                    let iImageItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(1), heightDimension: .absolute(150) ))
                    itemImages.append(iImageItem)
                }
                
            }
        }
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(150),
                                               heightDimension: .absolute(150))
        let imageGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: itemImages )
        
        
        //
        //        let imageGroup1 = NSCollectionLayoutGroup.custom(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(150))) { [self] environmentItem in
        //            var leftMargin: CGFloat = 0.0
        //            var yPosition: CGFloat = .zero
        //
        //            var customItem: [NSCollectionLayoutGroupCustomItem] = []
        //            var frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        //
        //            for image in modelImage {
        //
        //                var ratio: CGFloat = 0.0
        //                if let height = image.height, let width = image.width {
        //                    ratio = width / height
        ////                    let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150),
        ////                                                          heightDimension: .absolute(150))
        ////                    leftMargin = environmentItem.container.effectiveContentSize.width - width
        ////
        ////                    yPosition = itemSize.heightDimension.dimension + 10
        //
        //                    print(ratio)
        //
        //                    frame = CGRect(x: 0 , y: 0 , width: 150 * ratio, height: 200)
        //                }
        //
        //            }
        //
        //            customItem.append(NSCollectionLayoutGroupCustomItem(frame: frame))
        //
        //            return customItem
        //        }
        
        
        let section = NSCollectionLayoutSection(group: imageGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.supplementariesFollowContentInsets = false
        return section
        
    }
    
}



extension UICollectionViewDiffableDataSource {
    
    func replaceItems(_ items : [ItemIdentifierType], in section: SectionIdentifierType) {
        var currentSnapshot = snapshot()
        let itemsOfSection = currentSnapshot.itemIdentifiers(inSection: section)
        currentSnapshot.deleteItems(itemsOfSection)
        currentSnapshot.appendItems(items, toSection: section)
        currentSnapshot.reloadSections([section])
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


