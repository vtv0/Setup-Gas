//
//  FacilityImageView.swift
//  vehicle-dispatch-speed-up-app
//
//  Created by steshima on 2021/02/12.
//

import UIKit

struct DeliveryLocationImageUrl {
    let url: String?
    let imageType: DeliveryLocationImageType
  
    let order: Int

    var title: String {
        switch imageType {
        case .facilityExterior:
            return imageType.text
        case .gasLocation, .parking:
            return imageType.text + order.description
        }
    }
}

 class FacilityImageView: UIImageView {
    var imageUrl: DeliveryLocationImageUrl!

    init(frame: CGRect, imageUrl: DeliveryLocationImageUrl) {
        super.init(frame: frame)
        self.imageUrl = imageUrl
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        contentMode = .scaleAspectFit
    }
}
