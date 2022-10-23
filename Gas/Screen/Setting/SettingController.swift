//
//  SettingController.swift
//  Gas
//
//  Created by Vuong The Vu on 27/09/2022.
//

import UIKit

class SettingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title = "Setting "
        
        // self.navigationController?.navigationBar.backgroundColor = .systemBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
  
    @IBAction func btnLogOut(_ sender: Any) {
      //  UserDefaults.standard.removeObject(forKey: "accessToken")
        
       // self.showActivity()
        //        navigationController?.navigationItem =
       // let alert = UIAlertController(title: "Thông báo", message: "Bạn chắc chắn thoát ứng dụng", preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in action; i ") as! ViewController
            
        let secondViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
          //  let delay = 3
          //  DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) { [self] in
              //  self.hideActivity()//
               
                self.navigationController?.pushViewController(secondViewController, animated: true)
           // }
            

        
       // alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
       // self.present(alert, animated: true, completion: nil)
    }

}
