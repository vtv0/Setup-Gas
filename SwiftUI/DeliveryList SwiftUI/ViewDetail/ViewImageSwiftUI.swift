//
//  ViewImageSwiftUI.swift
//  Gas
//
//  Created by Vuong The Vu on 25/05/2023.
//

import SwiftUI


struct ViewImageSwiftUI: View {
    @State private var listImage: [UIImage] = []
    var body: some View {
        TabView {
            var listUrlImage = Location(elem: LocationElement(locationOrder: 0), asset: GetAsset(), createdAt: "").urls()
            
            
            ForEach(listImage, id: \.self) { iImageSwiftUI in
               
                Image(uiImage: iImageSwiftUI)
            }
            Image("application_splash_logo")
          
        }
       // .onChange(of: listImage) { newValue in
           
        //    print(listUrlImage)
         //   let imageSwiftUI: UIImageView!
//            ForEach(listUrlImage, id: \.self) { iurlImageSwiftUI in
//
//                print(iurlImageSwiftUI)
////                imageSwiftUI.downloaded(from: iurlImageSwiftUI)
////
////                listUrlImage.append(imageSwiftUI)
//
//            }
            
   //     }
        .tabViewStyle(.page)
        .background(Color.gray)
    }
    
    
}

struct ViewImageSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        ViewImageSwiftUI()
    }
}
