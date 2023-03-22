//
//  ScreenExpandVC.swift
//  Gas
//
//  Created by Vuong The Vu on 14/02/2023.
//

import UIKit

protocol PassArrLocation: AnyObject {
    func selectedLocation(arrlocation: [Location])
}

class ScreenExpandVC: UIViewController {
    weak var delegate: PassArrLocation?
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func btnExit(_ sender: Any) {
        guard let loginScreen = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? ViewController else { return }
        navigationController?.pushViewController(loginScreen, animated: true)
    }
    
    
    let screenExplandPrisenter = ScreenExpland_Presenter()
    var listDate = [Date]()
    var createdAt = ""
    var dicData: [Date: [Location]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //        self.navigationController?.isNavigationBarHidden = true
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        listDate = screenExplandPrisenter.sevenDay()
        
        screenExplandPrisenter.loadDataDelegate = self
        screenExplandPrisenter.delegateLoginBlock = self
        
        //        Task {
        //            showActivity()
        //            await screenExplandPrisenter.requestAPI()
        //        }
        
        showActivity()
        screenExplandPrisenter.callAPI_Block()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TableView {
            let selectedRow = myTableView.indexPathForSelectedRow!.row
            if let locations = dicData[listDate[selectedRow]] { // dicData nguồn từ API
                let locationsIsCustomer = locations.filter( { $0.elem?.location?.locationType?.rawValue == "customer" })
                //                vc.dateSelected = listDate[selectedRow]
                vc.locationsIsCustomer = locationsIsCustomer
                //                vc.loadInfo_DBorAPI(dicData: dicData, createdAt: createdAt)
            }
        } else if let vc = segue.destination as? ViewCollection {
            let selectedRow = myTableView.indexPathForSelectedRow!.row
            if let locations = dicData[listDate[selectedRow]] { // dicData nguồn từ API
                let locationsIsCustomer = locations.filter( { $0.elem?.location?.locationType?.rawValue == "customer" })
                //                vc.dateSelected = listDate[selectedRow]
                vc.locationsIsCustomer = locationsIsCustomer
                //                vc.loadInfo_DBorAPI(dicData: dicData, createdAt: createdAt)
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
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       let cell = myTableView.cellForRow(at: indexPath) as! ScreenExpand_TableViewCell
//        let storyBoard = UIStoryboard(name: "ListCollectionView", bundle: nil)
//        guard let collectionView = storyBoard.instantiateViewController(withIdentifier: "ViewCollection") as? ViewCollection else { return }
//        delegate = collectionView 
//        
//        if let locations = dicData[listDate[indexPath.row]] { // dicData nguồn từ API
//            let locationsIsCustomer = locations.filter( { $0.elem?.location?.locationType?.rawValue == "customer" })
//            delegate?.selectedLocation(arrlocation: locationsIsCustomer)
//        }
//    }
}

extension ScreenExpandVC: PassDelegateProtocol {
    func errorGetLastWorkerLocationList(error: Error) {
        let getElemError = error as? GetWorkerRouteLocationList_Block.CaseError
        DispatchQueue.main.async { [self] in
            if getElemError == .tokenOutOfDate {
                let scrLogin = storyboard?.instantiateViewController(withIdentifier: "LoginViewController" ) as! ViewController
                self.navigationController?.pushViewController(scrLogin, animated: false)
                hideActivity()
                showAlert(message: "Token hết hạn Login lại")
            } else if getElemError == .wrong {
                hideActivity()
                showAlert(message: "Không giao hàng hôm nay")
            } else {
                hideActivity()
                //                showAlert(message: "Có lỗi xảy ra")
            }
        }
    }
    func errorGetMe(error: Error) {
        let err = error as? GetMe_Block.CaseError
        DispatchQueue.main.async { [self] in
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
    }
    
    //    func errorGetLastWorkerLocationList(error: Error) {
    //        let errGetLast = error as? GetWorkerRouteLocationList_Async_Await.AFError
    //        DispatchQueue.main.async { [self] in
    //            if errGetLast == .tokenOutOfDate {
    //                let scrLogin = storyboard?.instantiateViewController(withIdentifier: "LoginViewController" ) as! ViewController
    //                self.navigationController?.pushViewController(scrLogin, animated: false)
    //                hideActivity()
    //                showAlert(message: "Token hết hạn Login lại")
    //            } else if errGetLast == .notDelivery {
    //                hideActivity()
    //                showAlert(message: "Không giao hàng hôm nay")
    //            } else if errGetLast == .wrong {
    //                hideActivity()
    //                showAlert(message: "Có lỗi xảy ra")
    //            } else {
    //                hideActivity()
    //                showAlert(message: "Có lỗi xảy ra")
    //            }
    //        }
    //    }
    
    //    func errorGetMe(error: Error) {
    //        let err = error as? GetMe_Async_Await.AFError
    //        DispatchQueue.main.async { [self] in
    //            if err == .tokenOutOfDate {
    //                let scrLogin = storyboard?.instantiateViewController(withIdentifier: "LoginViewController" ) as! ViewController
    //                self.navigationController?.pushViewController(scrLogin, animated: false)
    //                hideActivity()
    //                showAlert(message: "Token hết hạn Login lại")
    //            } else if err == .wrongPassword {
    //                showAlert(message: "Nhập sai password")
    //                hideActivity()
    //            } else {
    //                showAlert(message: "Có lỗi xảy ra")
    //                hideActivity()
    //            }
    //        }
    //    }
    
    
    
    func LoginOK(dicData: [Date: [Location]], date7: [Date] ) {
        //                    DispatchQueue.main.async {  // luong chinh
        //                        self.hideActivity()
        //                        // chuyen man hinh dung keo tha
        //                        self.dicData = dicData  // xong API moi co du lieu cua dic
        //                        self.listDate = date7
        //                    }
    }
    
    
    
}

extension ScreenExpandVC: Login_Block {
    func login(dicData: [Date : [Location]], createdAt: String?) {
        self.dicData = dicData
        self.createdAt = createdAt ?? ""
        self.hideActivity()
    }
}
