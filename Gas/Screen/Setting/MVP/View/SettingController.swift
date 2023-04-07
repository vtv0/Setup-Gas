//
//  SettingController.swift
//  Gas
//
//  Created by Vuong The Vu on 27/09/2022.
//

import UIKit

class SettingController: UIViewController {
    
    var settingPrisenter = PresenterSetting()
    
    @IBOutlet weak var lblVersion: UILabel!
    
    @IBOutlet weak var switchHighway: UISwitch!
    @IBAction func switchHighway(_ sender: Any) {
        print("switch")
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "", message: "Would you like to continue Logout?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
            
            // xoa User defaultl khi Logout
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "pass")
            UserDefaults.standard.removeObject(forKey: "companyCode")
            UserDefaults.standard.removeObject(forKey: "accessToken")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchHighway.setOn(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        if #available(iOS 13.0, *) {
            Task {
                await settingPrisenter.getVersion()  // gọi hàm thay cho btnclick
            }
        } else {
            // Fallback on earlier versions
        }
        settingPrisenter.delegateSetting = self
        
    }
    
}

extension SettingController: SettingDelegateProtocol {
    func passVersion(version: String) {
        self.lblVersion.text = version
    }
}


