//
//  PassScreenViewController.swift
//  Gas
//
//  Created by Vuong The Vu on 21/10/2022.
//

import UIKit

class PassScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Token: \( String(describing: UserDefaults.standard.value(forKey: "accessToken")))")
        
        if (UserDefaults.standard.value(forKey: "accessToken") != nil) {
            
            print("da co token")
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "DeliveryListController") as! DeliveryListController
            self.navigationController?.pushViewController(vc, animated: false)
            
            
        } else {
            print("chua co token")
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        
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
