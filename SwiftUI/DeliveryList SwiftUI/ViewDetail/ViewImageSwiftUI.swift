//
//  ViewImageSwiftUI.swift
//  Gas
//
//  Created by Vuong The Vu on 25/05/2023.
//

import SwiftUI


struct ViewImageSwiftUI: View {
    
    @Binding var elementsImageSwiftUI: [String]
  
    var body: some View {
        TabView {
            var viewImageSwiftUI: UIImageView!
                ForEach(elementsImageSwiftUI, id: \.self) { iImageSwiftUI in
           
           
                viewImageSwiftUI.downloaded(from: iImageSwiftUI)
            }
        }
        //        .frame(maxWidth: .infinity, maxHeight: 350)
   
        .tabViewStyle(.page)
        .background(Color.gray)
    }
}

struct ViewImageSwiftUI_Previews: PreviewProvider {
    @State static var elementsImageSwiftUI: [String] = []
    static var previews: some View {
        ViewImageSwiftUI(elementsImageSwiftUI: $elementsImageSwiftUI)
    }
}
