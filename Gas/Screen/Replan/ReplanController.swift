//
//  ReplanController.swift
//  Gas
//
//  Created by Vuong The Vu on 27/09/2022.
//

import UIKit
import FloatingPanel

class ReplanController: UIViewController, FloatingPanelControllerDelegate {
    let viewBtnAnimation = UIButton()
    var car: [String] = ["Car1", "Car2", "Car3", "Car4", "Car5", "Car6", "Car7", "Car8", "Car9"]
    let fpc = FloatingPanelController()
   
    var status: Bool = false
    
    var dicData: [Date : [Location]] = [:]
    var dateYMD: [Date] = []
    
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnReplace: UIButton!
    
    
    
    @IBAction func btnClear(_ sender: Any) {
        print("bo chon")
        let view = fpc.contentViewController as! ContentReplanController
        view.selectedRows.removeAll()
        view.myTableView.reloadData()
    }
    
    
    @IBAction func btnReplace(_ sender: Any) {
        print("chuyen sang ngay khac")
        // let view = fpc.contentViewController as! ContentReplanController
        // view.myTableView.reloadData()
        //let alert =  UIAlertController
        
    }
    
    @IBAction func btnCancel_Replan(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var pickerDriver: UIPickerView!
    
    
    @IBOutlet weak var pickerDate: UIPickerView!
    
    
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var stackViewAnimation: UIStackView!
    
    
    @IBOutlet weak var viewPicker: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Replan"
        createViewBtnAnimation()
        self.sevenDay()
        fpc.delegate = self
        
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentReplanController") as? ContentReplanController else { return }
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
        pickerDriver.dataSource = self
        pickerDriver.delegate = self
        pickerDate.dataSource = self
        pickerDate.delegate = self
        
        view.bringSubviewToFront(btnClear)
        view.bringSubviewToFront(btnReplace)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    func createViewBtnAnimation () {
        
        viewBtnAnimation.frame = CGRect(x: 0, y: 270, width: self.viewAnimation.frame.width, height: 30)
        viewBtnAnimation.backgroundColor = .white
        viewBtnAnimation.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        viewBtnAnimation.setImage(UIImage(named: "upAnimation"), for: .normal)
        self.view.addSubview(viewBtnAnimation)
    }
    
 
    @objc func clickBtn() {
        print("click BTN")
        status = !status
        if (status){
            viewAnimation.isHidden = true
            viewBtnAnimation.setImage(UIImage(named: "downAnimation"), for: .normal)
            viewBtnAnimation.frame = CGRect(x: 0, y: 160, width: self.viewAnimation.frame.size.width, height: 30)
            //viewBtnAnimation.b
            
        } else {
            viewAnimation.isHidden = false
            
            viewBtnAnimation.setImage(UIImage(named: "upAnimation"), for: .normal)
            viewBtnAnimation.frame = CGRect(x: 0, y: 270, width: self.viewAnimation.frame.size.width, height: 30)
            // viewBtnAnimation.layer.borderWidth = 1.0
            
        }
        
    }
    
}

extension ReplanController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func sevenDay() {
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                dateYMD.append(date1)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerDriver {
            return car.count
        } else if pickerView == pickerDate {
            return dateYMD.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerDriver {
            return car[row]
        } else if pickerView == pickerDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            let dateString: String = formatter.string(from: dateYMD[row])
            return dateString
        }
        return ""
    }
}
