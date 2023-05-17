//
//  UISheetSwiftUI.swift
//  Gas
//
//  Created by Vuong The Vu on 16/05/2023.
//

import SwiftUI

struct UISheetSwiftUI: View {
    @State private var showSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            Text("Hello cac bon")
                .presentationDetents([
                .custom(CustomSheets.self), .height(650)])
                .interactiveDismissDisabled()
        }
    }
}

struct CustomSheets: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        if context.dynamicTypeSize.isAccessibilitySize {
            return 650
        } else {
            return 160
        }
    }
}

struct UISheetSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        UISheetSwiftUI()
    }
}
