//
//  ViewImageSwiftUI.swift
//  Gas
//
//  Created by Vuong The Vu on 25/05/2023.
//

import SwiftUI

struct ViewImageSwiftUI: View {
    
    var elementsImageSwiftUI: [String]
   static   var viewImageSwiftUI: UIImageView!
    
    var body: some View {
        TabView {
           
            ForEach(self.elementsImageSwiftUI, id: \.self) { iImageSwiftUI in
           
//           Text(iImageSwiftUI)
                viewImageSwiftUI.downloaded(from: iImageSwiftUI)
            }
        }
        //        .frame(maxWidth: .infinity, maxHeight: 350)
   
        .tabViewStyle(.page)
        .background(Color.gray)
    }
}

struct ViewImageSwiftUI_Previews: PreviewProvider {
    static var elementsImageSwiftUI: [String] = []
    static var previews: some View {
        ViewImageSwiftUI(elementsImageSwiftUI: elementsImageSwiftUI)
    }
}
