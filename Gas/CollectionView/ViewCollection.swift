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
    
    var modelImage: [SizeImage] = []
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
                guard let cellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexPath) as? CellImage else { fatalError("Cannot create new cell") }
                
                cellImage.imgImageCollectionCell.loadImageDBorAPI(iurl: identifier) { [self] in
                    
                    if let height = cellImage.heightImage(),
                       let width = cellImage.widthImage() {
                        
                        let sizeImage: SizeImage = SizeImage(url: identifier, width: width, height: height)
                        
                        modelImage.append(sizeImage)
                    }
                    
                    //                      cellImage.frame.size.width = cellImage.frame.size.height * ratio
                    
                    //                    cellImage.widthAnchor.constraint(equalTo: cellImage.heightAnchor, multiplier: ratio).isActive = true
                    
                    let ilocation = locationsIsCustomer[(indexPath.section) / 2 ]
                    
                    if ilocation.urls().isEmpty {
                        print("sss")
                    } else {
                        
                    }
                    
                    
                    
                }
                
                
                //                 createLayout().collectionView?.reloadData()
                self.myCollectionView.collectionViewLayout.invalidateLayout()
                //                                myCollectionView.reloadData()
                return cellImage
            }
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<SectionIndex, String>()
        
        locationsIsCustomer.enumerated().forEach { ind, ilocation in
            
            snapshot.appendSections([SectionIndex(index: ind * 2)])
            
            snapshot.appendItems([(ilocation.elem?.metadata?.customer_id)! ])
            
            snapshot.appendSections([SectionIndex(index: ind * 2 + 1 )])
            for (_, i) in ilocation.urls().enumerated() {
                if ilocation.urls().isEmpty {
                    print("Not Image")
                    snapshot.deleteSections([SectionIndex(index: ind * 2 + 1 )])
                } else {
                    snapshot.appendItems([i])
                }
            }
        }
        
        dataSource?.apply(snapshot)
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [self] indSection, env -> NSCollectionLayoutSection? in
            switch indSection % 2 == 0 {
            case true:
                return listLayout()
                
            case false:
                let ilocation = locationsIsCustomer[indSection / 2]
                if ilocation.urls().isEmpty {
                    return listLayout()
                } else {
                    return imageLayout()
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
    
    func imageLayout() -> NSCollectionLayoutSection {
        
        modelImage.forEach { image in
            var ratio: CGFloat = 0.0
            if let height = image.height, let width = image.width {
                ratio = width / height
                // let createItemSize = NSCollectionLayoutItem(layoutSize: <#T##NSCollectionLayoutSize#>)
            }
        }
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(300),
                                              heightDimension: .absolute(150))
        let itemImage1 = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let itemSize2 = NSCollectionLayoutSize(widthDimension: .absolute(100),
                                               heightDimension: .absolute(150))
        let itemImage2 = NSCollectionLayoutItem(layoutSize: itemSize2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(150 * 1),
                                               heightDimension: .absolute(150))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [itemImage1, itemImage2])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.supplementariesFollowContentInsets = false
        
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


