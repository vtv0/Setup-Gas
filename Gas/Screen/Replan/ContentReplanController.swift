//
//  ContentReplanController.swift
//  Gas
//
//  Created by Vuong The Vu on 28/09/2022.
//

import UIKit

//protocol

class ContentReplanController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   // var items = [String]()
    var selectedRows: [IndexPath] = []
    var data = ["HaNoi", "HaiPhong", "Hue", "DaNang", "DongNai", "VinhPhuc", "CaMau", "KhanhHoa", "Hai Duong", "Thai Binh", "Hue", "Ha Tinh"]
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //myTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func deleteRows() {
        if let selectedRows = myTableView.indexPathsForSelectedRows {
            // 1
            var items = [String]()
            for indexPath in selectedRows  {
                items.append(data[indexPath.row])
            }
            // 2
            for item in items {
                if let index = data.firstIndex(of: item) {
                    data.remove(at: index)
                }
            }
            // 3
            //myTableView.beginUpdates()
            myTableView.deleteRows(at: selectedRows, with: .automatic)
            //myTableView.endUpdates()
            myTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "ContentReplanTableViewCell", for: indexPath) as? ContentReplanTableViewCell
        cell?.lblContent.text = data[indexPath.row]
        cell?.btnCheckbox.setImage(UIImage(named: "checkboxEmpty"), for: .normal)
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = myTableView.cellForRow(at: indexPath) as? ContentReplanTableViewCell else {
            return
        }
        print("click vao cell,\(indexPath.row)")
        if self.selectedRows.contains(indexPath) {
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
            cell.btnCheckbox.setImage(UIImage(named:"checkboxEmpty"), for: .normal)
            
        } else {
            self.selectedRows.append(indexPath)
            cell.btnCheckbox.setImage(UIImage(named:"checkbox"), for: .normal)
            
        }
        cell.selectionStyle = .none
        myTableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}
