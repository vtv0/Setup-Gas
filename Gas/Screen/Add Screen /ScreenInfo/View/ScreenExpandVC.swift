//
//  ScreenExpandVC.swift
//  Gas
//
//  Created by Vuong The Vu on 14/02/2023.
//

import UIKit

class ScreenExpandVC: UIViewController {
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    let screenExpland = ScreenExpland_Presenter()
    var listDate = [Date]()
    var dicData: [Date: [Location]] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //        self.navigationController?.isNavigationBarHidden = true
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        listDate = screenExpland.sevenDay()
        screenExpland.loadDataDelegate = self
        Task {
            showActivity()
            await screenExpland.requestAPI()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if let nav = segue.destination as? UINavigationController,
        //           let edit = nav.viewControllers.first as? TableView {
        //            let selectedRow = myTableView.indexPathForSelectedRow!.row
        //
        //            if let locations = dicData[listDate[selectedRow]] {
        //                let locationsIsCustomer = locations.filter( { $0.elem?.location?.locationType?.rawValue == "customer" })
        //                edit.locationsIsCustomer = locationsIsCustomer
        //
        //            }
        //        }
        
        
        
        if let vc = segue.destination as? TableView {
            let selectedRow = myTableView.indexPathForSelectedRow!.row
            if let locations = dicData[listDate[selectedRow]] {
                let locationsIsCustomer = locations.filter( { $0.elem?.location?.locationType?.rawValue == "customer" })
                vc.locationsIsCustomer = locationsIsCustomer
                
            }
        }
    }
    
    
    
    func showAlert(title: String? = "", message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
}

extension ScreenExpandVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier:  "ScreenExpand_TableViewCell", for: indexPath) as! ScreenExpand_TableViewCell
        cell.lblDate.text = "\(listDate[indexPath.row])"
        return cell
    }
}

extension ScreenExpandVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = myTableView.cellForRow(at: indexPath) as! ScreenExpand_TableViewCell
        print(cell)
    }
}

extension ScreenExpandVC: PassDelegateProtocol {
    func errorGetLastWorkerLocationList(error: Error) {
        let errGetLast = error as? GetWorkerRouteLocationList_Async_Await.AFError 
        if errGetLast == .tokenOutOfDate {
            let scrLogin = storyboard?.instantiateViewController(withIdentifier: "LoginViewController" ) as! ViewController
            self.navigationController?.pushViewController(scrLogin, animated: false)
            hideActivity()
            showAlert(message: "Token hết hạn Login lại")
        } else if errGetLast == .notDelivery {
            hideActivity()
            showAlert(message: "Không giao hàng hôm nay")
        } else if errGetLast == .wrong {
            //
        } else {
            hideActivity()
            showAlert(message: "Có lỗi xảy ra")
        }
    }
    
    func errorGetMe(error: Error) {
        let err = error as? GetMe_Async_Await.AFError
        if err == .tokenOutOfDate {
            let scrLogin = storyboard?.instantiateViewController(withIdentifier: "LoginViewController" ) as! ViewController
            self.navigationController?.pushViewController(scrLogin, animated: false)
            hideActivity()
            showAlert(message: "Token hết hạn Login lại")
        } else if err == .wrongPassword {
            showAlert(message: "Nhập sai password")
            hideActivity()
        } else {
            showAlert(message: "Có lỗi xảy ra")
            hideActivity()
        }
    }
    
    func loadDataSource() {
        DispatchQueue.main.async {
            
        }
    }
    
    func LoginOK(dicData: [Date: [Location]]) {
        DispatchQueue.main.async {
            self.hideActivity()
            // chuyen man hinh dung keo tha
            self.dicData = dicData
        }
    }
    
}
