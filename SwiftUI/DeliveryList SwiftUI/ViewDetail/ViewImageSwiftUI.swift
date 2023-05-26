//
//  ViewImageSwiftUI.swift
//  Gas
//
//  Created by Vuong The Vu on 25/05/2023.
//

import SwiftUI


struct ViewImageSwiftUI: View {
    
//    @Binding var elementsImageSwiftUI: [String]
    
    
    var body: some View {
        TabView {
            
//            ForEach(elementsImageSwiftUI, id: \.self) { iImageSwiftUI in
//                Text(iImageSwiftUI)
////                Image(uiImage: iImageSwiftUI)
//            }
        }
        //        .frame(maxWidth: .infinity, maxHeight: 350)
        .tabViewStyle(.page)
        .background(Color.gray)
    }
}

struct ViewImageSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        ViewImageSwiftUI()
    }
}
