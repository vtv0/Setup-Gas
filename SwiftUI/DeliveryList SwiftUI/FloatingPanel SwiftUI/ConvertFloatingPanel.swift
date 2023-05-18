//
//  ConvertFloatingPanel.swift
//  Gas
//
//  Created by Vuong The Vu on 15/05/2023.
//

import SwiftUI
import UIKit
import FloatingPanel


struct ConvertFloatingPanel: View {
    
    
    typealias UIViewControllerType = FloatingPanelLayout
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            // FloatingPanelDeliveryVC()
        }
        .ignoresSafeArea(.all)
    }
}

struct ConvertFloatingPanel_Previews: PreviewProvider {
    static var previews: some View {
        ConvertFloatingPanel()
    }
}

struct FloatingPanel: UIViewControllerRepresentable {
    //    typealias UIViewControllerType = MyFloatingPanelLayout
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let floatingPanel = MyFloatingPanelLayout()
        let vc = UIViewController()
        //        floatingPanel.btnShipping.backgroundColor = .red
//        vc.addChild(floatingPanel)
        
        //        floatingPanel.mapView?.translatesAutoresizingMaskIntoConstraints = false
        //        floatingPanel.translatesAutoresizingMaskIntoConstraints = false
        //        NSLayoutConstraint.activate([
        //            floatingPanel.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
        //            floatingPanel.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
        //            floatingPanel.topAnchor.constraint(equalTo: viewController.view.topAnchor),
        //            floatingPanel.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
        //                ])
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    
}
