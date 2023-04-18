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

class PHAssetCollection: UIViewController {
    
    weak var delegatePassImage: PassImage?
    
    @IBOutlet weak var collectionPhoto: UICollectionView!
    
    // click de truyen [image]
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        listImg = getAssetThumbnail(assets: imagesPHAsset)
        let imagesOK = arrImageSelected(images: listImg, indexPath: listImageSelected)
        
        if imagesOK.isEmpty {
            dismiss(animated: true)
        } else {
            self.delegatePassImage?.passImage(images: imagesOK)
        }
    }
    var photoIsAvailable: Int = 0
    var clickedCellPosition: Int = 0
    
    var listImg: [UIImage] = []
    var listPngData: [NSData] = []
    
    var listImageSelected  = [IndexPath]()
    var imagesPHAsset = [PHAsset]()
    let accessLevel: PHAccessLevel = .readWrite
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
        title = "Selection Photo"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "BACK", style: .plain, target: nil, action: nil)
        collectionPhoto.dataSource = self
        collectionPhoto.delegate = self
    }
    
    // Convert array of PHAsset to UIImages
    func getAssetThumbnail(assets: [PHAsset]) -> [UIImage] {
        var arrayOfImages = [UIImage]()
        for asset in assets {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var image = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                image = result!
                arrayOfImages.append(image)
            })
        }
        return arrayOfImages
    }
    
    func arrImageSelected(images: [UIImage], indexPath: [IndexPath]) -> [UIImage] {
        var listImage = [UIImage]()
        
        for iIndexPath in indexPath {
            let indexPath: IndexPath = iIndexPath
            let rowNumber: Int = indexPath.row
            let img = images[rowNumber]
            listImage.append(img)
           
        }
        
        
        return listImage
    }
    
    func showAlert(title: String? = "", message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
    func populatePhotos() {
        PHPhotoLibrary.requestAuthorization(for: accessLevel) { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object, _, _) in
                    self?.imagesPHAsset.append(object)
                }
                self?.imagesPHAsset.reverse()
                DispatchQueue.main.async {
                    self?.collectionPhoto.reloadData()
                }
            }
        }
    }
    
}

extension PHAssetCollection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesPHAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellPHAsset = collectionView.dequeueReusableCell(withReuseIdentifier: "PHAssetCollectionCell", for: indexPath) as? PHAssetCollectionCell else { fatalError ("Cannot create new cell") }
        let asset = self.imagesPHAsset[indexPath.item]
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


extension PHAssetCollection: UICollectionViewDelegate {  // list image
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.listImageSelected.contains(indexPath) {
            self.listImageSelected.remove(at: self.listImageSelected.firstIndex(of: indexPath)!)
        } else {
            if listImageSelected.count < (8 - photoIsAvailable - clickedCellPosition) {
                listImageSelected.append(indexPath)
            } else {
                showAlert(message: "Quá số lượng ảnh được chọn")
            }
           
        }
        collectionPhoto.reloadItems(at: [indexPath])
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


