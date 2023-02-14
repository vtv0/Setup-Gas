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
    var listStringDate = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        
        listStringDate = screenExpland.arrStringDate()
        screenExpland.loadDataDelegate = self
        Task {
            showActivity()
            await screenExpland.requestAPI()
        }
    }
    
}

extension ScreenExpandVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listStringDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier:  "ScreenExpand_TableViewCell", for: indexPath) as! ScreenExpand_TableViewCell
        cell.lblDate.text = listStringDate[indexPath.row]
        
        return cell
    }
    
    
}

extension ScreenExpandVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = myTableView.cellForRow(at: indexPath) as? ScreenExpand_TableViewCell else { return }
        print(cell)
        
        
    }
}

extension ScreenExpandVC : PassDelegateProtocol {
    func loadDataSource() {
        //
    }
    
    func LoginOK() {
        print("ok ok ok")
        DispatchQueue.main.async {
            self.hideActivity()
            
        }
       
    }
    
    
}
