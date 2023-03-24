//
//  ViewCollection.swift
//  Gas
//
//  Created by Vuong The Vu on 17/03/2023.
//

import UIKit

//enum Section: Int, CaseIterable, Hashable {
//    case hasImage = 1
//    case notImage = 0
//}

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
    
    var dataSource: UICollectionViewDiffableDataSource<SectionIndex, Location>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.collectionViewLayout = createLayout()
        
        configureDataSource()
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionIndex, Location>(collectionView: myCollectionView) { [self]
            (collectionView: UICollectionView, indexPath: IndexPath, ilocation: Location) -> UICollectionViewCell? in
            
            // switch Sec(rawValue: indexPath.section) {
            //  case .notImage :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",for: indexPath) as? CollectionViewCell else { fatalError("Cannot create new cell") }
            
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
            
          
             
//                case .hasImage:
//                    guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexPath) as? CellImage else { fatalError("Cannot create new cell") }
//                    imageCell.imgImageCollectionCell.image = UIImage(named: "application_splash_logo")
//                    return imageCell
//
//                case .none:
//                    break
//                }
                
            
            
            return UICollectionViewCell()
            
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<SectionIndex, Location>()
        for (ind, ilocation) in locationsIsCustomer.enumerated() {
            snapshot.appendSections([.init(index: ind)])
            //        snapshot.appendSections([.notImage])
            snapshot.appendItems([ilocation])
            
            //            snapshot.appendSections([.hasImage])
//            snapshot.appendItems(Array(0...ilocation.urls().count))
            
        }
        dataSource.apply(snapshot)
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
        //    switch Section(rawValue: sectionNumber) {
          //  case .notImage:
                return self.listLayout()
          //  case .hasImage:
            //    return self.imageLayout()
           // default:
            //    return nil
           // }
        }
    }
    
    func listLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(110))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(12), trailing: nil, bottom: .fixed(12))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(110))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        // let layout = UICollectionViewCompositionalLayout(section: section)
        return section
    }
    
    func imageLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let itemImage = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(70),
                                               heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [itemImage])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.supplementariesFollowContentInsets = false
        // let layout = UICollectionViewCompositionalLayout(section: section)
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


