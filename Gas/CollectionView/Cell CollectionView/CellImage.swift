//
//  CellImage.swift
//  Gas
//
//  Created by Vuong The Vu on 21/03/2023.
//

import UIKit

class CellImage: UICollectionViewCell {
    
    @IBOutlet weak var imgImageCollectionCell: UIImageView!
    
    func heightImage() -> CGFloat? {
       return self.imgImageCollectionCell.bounds.height
    }
    func widthImage() -> CGFloat? {
       return self.imgImageCollectionCell.bounds.width
    }
}
