//
//  PHAsset.swift
//  Gas
//
//  Created by Vuong The Vu on 07/04/2023.
//

import UIKit
import Photos
import PhotosUI

protocol PassImage: AnyObject {
    func passImage(images: [UIImage])
}

class PHAssetCollection: UIViewController, UICollectionViewDataSource {
    
    weak var delegatePassImage: PassImage?
    var listImg: [UIImage] = []
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.delegatePassImage?.passImage(images: listImg)
        
    }
    
    @IBOutlet weak var collectionPhoto: UICollectionView!
    var listImageSelected  = [IndexPath]()
    var images = [PHAsset]()
    let accessLevel: PHAccessLevel = .readWrite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
        
        title = "Selection Photo"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        //        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "BACK", style: .plain, target: nil, action: nil)
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
        manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cellPHAsset.imgCollectionCell?.image = image
                cellPHAsset.imgCheck.image = UIImage(named: "ic_radio_checked")
            }
            
            if self.listImageSelected.contains(indexPath) {
                cellPHAsset.imgCheck.isHidden = false
                
            } else {
                cellPHAsset.imgCheck.isHidden = true
            }
        }
        return cellPHAsset
    }
}


extension PHAssetCollection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellDidSelected = collectionPhoto.cellForItem(at: indexPath) as? PHAssetCollectionCell else { return }
        if self.listImageSelected.contains(indexPath) {
            self.listImageSelected.remove(at: self.listImageSelected.firstIndex(of: indexPath)!)
            // xoa listImg
            
        } else {
            listImageSelected.append(indexPath)
            if let img = cellDidSelected.imgCollectionCell?.image {
                listImg.append(img)
            }
        }
        collectionPhoto.reloadData()
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


