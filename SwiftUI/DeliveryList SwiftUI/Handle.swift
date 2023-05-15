//
//  Handle.swift
//  Gas
//
//  Created by Vuong The Vu on 15/05/2023.
//

import SwiftUI

struct Handle : View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
      
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.red)
            .padding(5)
    }
}
