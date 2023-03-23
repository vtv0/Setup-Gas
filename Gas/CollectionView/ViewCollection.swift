//
//  ViewCollection.swift
//  Gas
//
//  Created by Vuong The Vu on 17/03/2023.
//

import UIKit

enum Section {
    case hasImage
    case notImage
}

class ViewCollection: UIViewController {
    
    var locationsIsCustomer: [Location] = []
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Location>
    typealias DataSource = UICollectionViewDiffableDataSource< Section, Location>
    
    @IBOutlet weak var
myCollectionView: UICollectionView!
    
    lazy private var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.collectionViewLayout = listSection()
        
        // myCollectionView.delegate = self  // layout
        
           myCollectionView.dataSource = self // Content
        
//        myCollectionView.dataSource = makeDataSource()
//        apply()
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: myCollectionView,
            cellProvider: { (collectionView, indexPath, ilocation) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
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
        )
        return dataSource
    }
    
    func apply() {
        var snapshot = Snapshot()
        snapshot.appendSections([.hasImage])
        snapshot.appendItems(locationsIsCustomer)
        dataSource.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
//        UICollectionViewCompositionalLayout(section: Section.)
        //if ilocation.urls() {
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
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
//        } else {
//           let layout = listSection()
//            return layout
//        }
        
    }
    
    func listSection() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(110))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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

extension ViewCollection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        for ilocation in locationsIsCustomer {
            print(ilocation.urls())
        }
        return locationsIsCustomer.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    if
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
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
//        else  add cell Image
        guard let cellImage = myCollectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexPath) as? CellImage else { return UICollectionViewCell() }
        cellImage.imgImageCollectionCell.image = UIImage(named: "application_splash_logo")
        return cellImage
    }
}

