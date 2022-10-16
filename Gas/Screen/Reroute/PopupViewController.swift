//
//  PopupViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 10/10/2022.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var btnReroute: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var customView: UIView!
    
    @IBOutlet weak var lblInfomation: UILabel!
    @IBOutlet weak var lblInfo2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        customView.isHidden = false
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
