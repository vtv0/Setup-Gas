//
//  PHAsset.swift
//  Gas
//
//  Created by Vuong The Vu on 07/04/2023.
//

import UIKit
import Photos
import PhotosUI

class PHAssetCollection: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionPhoto: UICollectionView!
    
    var images = [PHAsset]()
    let accessLevel: PHAccessLevel = .readWrite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
        
        collectionPhoto.dataSource = self
        collectionPhoto.delegate = self
    }
    
    func populatePhotos() {
        PHPhotoLibrary.requestAuthorization(for: accessLevel) { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assets.enumerateObjects { (object, _, _) in
                    self?.images.append(object)
                }
                
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionPhoto.reloadData()
                }
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images.count)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellPHAsset = collectionView.dequeueReusableCell(withReuseIdentifier: "PHAssetCollectionCell", for: indexPath) as? PHAssetCollectionCell else { fatalError("Cannot create new cell") }
        let asset = self.images[indexPath.item]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cellPHAsset.imgCollectionCell?.image = image
                
            }
            
        }
        return cellPHAsset
    }
    
}
