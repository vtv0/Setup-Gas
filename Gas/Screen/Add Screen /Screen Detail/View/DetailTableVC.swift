//
//  DetailTableVC.swift
//  Gas
//
//  Created by Vuong The Vu on 14/02/2023.
//

import UIKit

class DetailTableVC: UIViewController {
    
    @IBOutlet weak var myTableViewDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableViewDetail.dataSource = self
        
        myTableViewDetail.dataSource = self
        myTableViewDetail.rowHeight = 150
    }
}


extension DetailTableVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 19
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDetail = myTableViewDetail.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell
        cellDetail.lblCustomerCode.text = "1"
        
        return cellDetail
    }
}


extension DetailTableVC: UITableViewDelegate {
    
}
