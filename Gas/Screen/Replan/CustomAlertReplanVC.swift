//
//  CustomAlertReplanVC.swift
//  Gas
//
//  Created by Vuong The Vu on 12/10/2022.
//

import UIKit


protocol ClickOkDelegateProtocol: AnyObject {
    func clickOk(dicMoveTo: [Int: [Location]])
}

class CustomAlertReplanVC: UIViewController {
    
    
    weak var delegateClickOK: ClickOkDelegateProtocol?
    
    var dicMoveTo: [Int: [Location]] = [:]
    var listMoveToLocation: [Location] = []
    
    var date: String = ""
    var totalNumberOfBottle: Int = 0
    var totalCellSelect: Int = 0
    var displayInfomation: String = ""
    var selectedIdxDate = 0
    
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var lbl_number: UILabel!
    @IBOutlet weak var lbl_changeType: UILabel!
    
    @IBOutlet weak var txt_displayInfomation: UITextView!
    
    @IBAction func btnCancel(_ sender: Any) {
        listMoveToLocation.removeAll()
        dismiss(animated: false)
    }
    @IBAction func btnOK(_ sender: Any) {
        dismiss(animated: false)
        delegateClickOK?.clickOk(dicMoveTo: dicMoveTo)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlert.layer.cornerRadius = 10
        viewAlert.layer.masksToBounds = true
       
        
        //tao Dictionary MoveToFirstDay
        dicMoveTo.updateValue(listMoveToLocation, forKey: selectedIdxDate)
        
        
        // loại bỏ điểm giao hàng ngày đầu tiên -> số lượng giảm
        if ( selectedIdxDate == 0) {
            txt_displayInfomation.text = "\( """
                                    ※ 選択された配送先は初日の配送へ移動されます。\n移動した配送先は計画に残りますが、次回計画作成時に除外されます。
                                    ※ 再作成後は配送順が変更となります (ngày hôm nay sang hôm sau)
                                    """ )"
            lbl_number.text = "\(totalNumberOfBottle)Bottle -> \(totalNumberOfBottle - totalCellSelect)Bottle"
            lbl_changeType.text = "\(date) Remove"
            
        } else {
            
            // chuyển điểm hàng từ ngày sau về ngày đầu -> số lượng tăng
            txt_displayInfomation.text = "\( """
                                    ※ 選択された配送先は初日の配送へ移動されます。 移動した配送先は計画に残りますが、次回計画作成時に除外されます。\n
                                    ※ 初日分の計画再作成には時間がかかります。 再作成後は配送順が変更となります。 別途当日内で入れ替えを実施してください。
                                    """ )"
            
            lbl_number.text = "\(totalNumberOfBottle)Bottle -> \(totalNumberOfBottle + totalCellSelect)Bottle"
            lbl_changeType.text = "\(date) Add"
            
        }
    }
    
}
