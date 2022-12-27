//
//  CustomAlertReplanVC.swift
//  Gas
//
//  Created by Vuong The Vu on 12/10/2022.
//

import UIKit


protocol ClickOkDelegateProtocol: AnyObject {
    func clickOk(listIndex: [Int])
}

class CustomAlertReplanVC: UIViewController {
    weak var delegateClickOK: ClickOkDelegateProtocol?
    // Exclude
   
    var listLocationOfDate = [Int: [Location]]()
    
    var date: String = ""
    var totalNumberOfBottle: Int = 0
    var totalCellSelect: Int = 0
    var displayInfomation: String = ""
    
    var selectedIdxDate = 0
    var selectedIdxDriver = 0
    var listIndex = [Int]()
    var numberGasAdd: Int = 0  // so luong binh chon de them
    var indxes = [Int]()
    
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var lbl_number: UILabel!
    @IBOutlet weak var lbl_changeType: UILabel!
    
    @IBOutlet weak var txt_displayInfomation: UITextView!
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: false)
    }
    @IBAction func btnOK(_ sender: Any) {
        dismiss(animated: false)
        delegateClickOK?.clickOk(listIndex: listIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlert.layer.cornerRadius = 10
        viewAlert.layer.masksToBounds = true
        
       
        calculateTheNumberOfGas()
    }
    
    func calculateTheNumberOfGas() {
        // number of Bottle added
//        for i in listMoveToLocation {
//            if let facility_dataDetail = i.elem?.metadata?.facility_data {
//                for inumber in facility_dataDetail {
//                    numberGasAdd += inumber.count ?? 0
//                }
//            }
//        }
        ShowInfomationOfAlert()
    }
    
    func ShowInfomationOfAlert() {
        // loại bỏ điểm giao hàng ngày đầu tiên -> số lượng giảm
        if selectedIdxDate == 0 {
            
            if  selectedIdxDriver + 1 == indxes.count + 1 {
                // chuyển điểm hàng từ DS REMOVE -> ban đầu (Ngày 1)
                txt_displayInfomation.text = "\( """
                                       ※ 選択された配送先は初日の配送へ移動されます。 移動した配送先は計画に残りますが、次回計画作成時に除外されます。\n
                                       ※ 初日分の計画再作成には時間がかかります。 再作成後は配送順が変更となります。 別途当日内で入れ替えを実施してください。
                                       """ )"
                
                lbl_number.text = "\(totalNumberOfBottle)Bottle -> \(totalNumberOfBottle + numberGasAdd)Bottle"
                lbl_changeType.text = "\(date) Add (Remove -> Date1)"
            } else {
                txt_displayInfomation.text = "\( """
                                    ※ 選択された配送先は初日の配送へ移動されます。\n移動した配送先は計画に残りますが、次回計画作成時に除外されます。
                                    ※ 再作成後は配送順が変更となります (ngày hôm nay sang hôm sau)
                                    """ )"
                lbl_number.text = "\(totalNumberOfBottle)Bottle -> \(totalNumberOfBottle - totalCellSelect)Bottle"
                lbl_changeType.text = "\(date) Remove"
            }
        } else {
            
            // chuyển điểm hàng từ ngày sau về ngày đầu -> số lượng tăng
            txt_displayInfomation.text = "\( """
                                    ※ 選択された配送先は初日の配送へ移動されます。 移動した配送先は計画に残りますが、次回計画作成時に除外されます。\n
                                    ※ 初日分の計画再作成には時間がかかります。 再作成後は配送順が変更となります。 別途当日内で入れ替えを実施してください。
                                    """ )"
            
            lbl_number.text = "\(totalNumberOfBottle)Bottle -> \(totalNumberOfBottle + numberGasAdd)Bottle"
            lbl_changeType.text = "\(date) Add"
            
        }
        
    }
}
