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
    let driver = ["n1", "n2", "n3"]
    let fpc = FloatingPanelController()
    let date = ["03/10", "04/10", "05/10", "06/10","07/10","08/10","09/10"]
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
    
    var status:Bool = false
    @objc
    func clickBtn() {
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return driver.count
        } else if (pickerView.tag == 1) {
            return date.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return driver[row]
        } else if (pickerView.tag == 1) {
            return date[row]
        }
        return ""
    }
}
