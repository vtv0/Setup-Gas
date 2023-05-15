//
//  ConvertFloatingPanel.swift
//  Gas
//
//  Created by Vuong The Vu on 15/05/2023.
//

import SwiftUI
import UIKit

struct ConvertFloatingPanel: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            FloatingPanel()
//            FloatingPanelDeliveryVC()
        }
        .ignoresSafeArea(.all)
      
    }
}

struct ConvertFloatingPanel_Previews: PreviewProvider {
    static var previews: some View {
        ConvertFloatingPanel()
    }
}


struct FloatingPanel: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        var view = UIView()
        view.backgroundColor = .yellow
        view = PageDetailVC()
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
  
    }
}
