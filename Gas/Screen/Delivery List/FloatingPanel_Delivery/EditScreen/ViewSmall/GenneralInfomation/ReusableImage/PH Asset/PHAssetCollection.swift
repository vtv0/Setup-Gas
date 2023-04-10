//
//  PHAsset.swift
//  Gas
//
//  Created by Vuong The Vu on 07/04/2023.
//

import UIKit
import Photos
import PhotosUI

class PHAssetCollection: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionPhoto: UICollectionView!
    
    var images = [PHAsset]()
    let accessLevel: PHAccessLevel = .readWrite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
        
        title = "Selection Photo"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.blue]
        
        collectionPhoto.dataSource = self
    
        collectionPhoto.delegate = self
//        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())  //
//        config.selectionLimit = 8
//        config.filter = .images
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = self
//       present(picker, animated: true)
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
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellPHAsset = collectionView.dequeueReusableCell(withReuseIdentifier: "PHAssetCollectionCell", for: indexPath) as? PHAssetCollectionCell else { fatalError ("Cannot create new cell") }
        let asset = self.images[indexPath.item]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 120, height: 120), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cellPHAsset.imgCollectionCell?.image = image
                cellPHAsset.lblNumberImage?.isHidden = true
            }
        }
        return cellPHAsset
    }
    
var listImageSelected  = [Int]()
}


extension PHAssetCollection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionPhoto.cellForItem(at: indexPath)
        listImageSelected.append(indexPath.item)
        
        
    
//        guard let cellPHAsset = collectionView.dequeueReusableCell(withReuseIdentifier: "PHAssetCollectionCell", for: indexPath) as? PHAssetCollectionCell else { fatalError ("Cannot create new cell") }
        
        if !listImageSelected.isEmpty {
            print(indexPath.item)
//            listImageSelected[indexPath.item]
//            cell.lblNumberImage?.isHidden = false
//            cellPHAsset.lblNumberImage?.text = "4"
//            collectionPhoto.reloadData()
        } else {
            print("chua chon anh nao")
        }
        
//        if cell?.isSelected == true {
//            cell?.isHidden = true
//        }
//        else {
//            cell?.backgroundColor = UIColor.clear
//        }
    }
}






//extension PHAssetCollection: PHPickerViewControllerDelegate {
//    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        let group = DispatchGroup()
//        results.forEach { result in
//            group.enter()
//            result.itemProvider.loadObject(ofClass: UIImage.self , completionHandler: { reading, err in
//                guard let image = reading as? PHAsset, err == nil else { return }
//                self.images.append(image)
//                group.leave()
//            })
//        }
//        group.notify(queue: .main) {
//            self.collectionPhoto.reloadData()
//        }
//    }
//}


