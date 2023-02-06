//
//  ShippingViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 09/01/2023.
//

import UIKit
import Alamofire

enum StatusDelivery: CaseIterable {
    case returnFailedToDeliver
    case unableToDeliver
    case complete
    
    var title: String {
        switch self {
            
        case .returnFailedToDeliver:
            return "Return failed to deliver"
        case .unableToDeliver:
            return "Unable to deliver"
        case .complete:
            return "Complete"
        }
    }
}

class ShippingViewController: UIViewController {
    
    var selectedRows = [IndexPath]()
    var dataInfoOneCustomer: Location = Location(elem: LocationElement(locationOrder: 0), asset: GetAsset(assetModelID: 0))
    
    @IBAction func btnExit(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        print("CLICK SUBMIT")
    }
    
    @IBOutlet weak var viewInfomation: UIView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblEstimateTime: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    

    
    let button = [UIButton]()
    let arrStatus = ["Return failed to deliver", "Unable to deliver", "Complete"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        title = "Determine delivery content"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        lblStatus.layer.cornerRadius = 8
        lblStatus.layer.masksToBounds = true
        
        lblCustomerName.text = dataInfoOneCustomer.asset?.properties?.values.customer_name
        lblDeliveryAddress.text = dataInfoOneCustomer.asset?.properties?.values.address
        if let minutes = dataInfoOneCustomer.elem?.arrivalTime?.minutes,
           let hours = dataInfoOneCustomer.elem?.arrivalTime?.hours {
            if minutes < 10 {
                lblEstimateTime?.text = "Estimate Time : \(hours):0\(minutes)"
            } else {
                lblEstimateTime?.text = "Estimate Time : \(hours):\(minutes)"
            }
        }
        
        setupRadioButton()
    }
    
    func setupRadioButton() {
        for iStatus in StatusDelivery.allCases {
            let statusView = ReuseViewRadioButton(frame: .zero)  //CGRect.init(x: 0, y: 0, width: 0, height: 100))
            statusView.status = iStatus
            statusView.loadInfo()
            stackView.addArrangedSubview(statusView)
            
        }
        
    }
    
}

extension ShippingViewController: PassStatusDelivery {
    func onTap(_ sender: ReuseViewRadioButton, number: Int) {
        print(number)
    }
    
    
}
