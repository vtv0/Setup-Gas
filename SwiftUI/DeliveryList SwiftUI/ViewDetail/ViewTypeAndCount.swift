//
//  ViewTypeAndCount.swift
//  Gas
//
//  Created by Vuong The Vu on 25/05/2023.
//

import SwiftUI

struct ViewTypeAndCount: View {
 
    var body: some View {
        HStack {
            Spacer()
            Text("50kg")
            Spacer()
            Spacer()
            Text("4")
            Spacer()
            
        }
        .border(.black)
    }
}

struct ViewTypeAndCount_Previews: PreviewProvider {
    static var previews: some View {
        ViewTypeAndCount()
    }
}
