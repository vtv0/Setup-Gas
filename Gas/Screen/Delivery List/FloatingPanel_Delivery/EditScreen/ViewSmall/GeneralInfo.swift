//
//  Tab1.swift
//  Gas
//
//  Created by Vuong The Vu on 03/10/2022.
//

import Foundation

class Demo1ViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    
    var name: String = ""
    
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = "\(name) View Controller"
    }
}
