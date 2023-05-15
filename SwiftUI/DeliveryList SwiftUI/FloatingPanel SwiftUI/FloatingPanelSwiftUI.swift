////
////  FloatingPanelSwiftUI.swift
////  Gas
////
////  Created by Vuong The Vu on 15/05/2023.
////
//
//import SwiftUI
//
//struct SlideOverCard<Content: View> : View {
//    @GestureState private var dragState = DragState.inactive
//    @State var position = CardPosition.bottom
//    
//    var content: () -> Content
//    var body: some View {
//        let drag = DragGesture()
//            .updating($dragState) { drag, state, transaction in
//                state = .dragging(translation: drag.translation)
//            }
//            .onEnded(onDragEnded)
//        
//        return Group {
//            Handle()
//            self.content()
//        }
//        
//        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
//        .background(Color.white)
//        .cornerRadius(10.0)
////        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
//        .offset(y: self.position.rawValue + self.dragState.translation.height)
//        
////        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
//        
//        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: position)
//        .gesture(drag)
//    }
//    
//    private func onDragEnded(drag: DragGesture.Value) {
//        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
//        let cardTopEdgeLocation = self.position.rawValue + drag.translation.height
//        let positionAbove: CardPosition
//        let positionBelow: CardPosition
//        let closestPosition: CardPosition
//        
//        if cardTopEdgeLocation <= CardPosition.bottom.rawValue {
//            positionAbove = .top
//            positionBelow = .bottom
//
//        } else {
//            positionAbove = .top
//            positionBelow = .bottom
//        }
//        
//        if (cardTopEdgeLocation - positionAbove.rawValue) < (positionBelow.rawValue - cardTopEdgeLocation) {
//            closestPosition = positionAbove
//        } else {
//            closestPosition = positionBelow
//        }
//        
//        if verticalDirection > 0 {
//            self.position = positionBelow
//        } else if verticalDirection < 0 {
//            self.position = positionAbove
//        } else {
//            self.position = closestPosition
//        }
//    }
//}
//
//enum CardPosition: CGFloat {
//    case top = 200
//    case bottom = 600
//}
//
//enum DragState {
//    case inactive
//    case dragging(translation: CGSize)
//    
//    var translation: CGSize {
//        switch self {
//        case .inactive:
//            return .zero
//        case .dragging(let translation):
//            return translation
//        }
//    }
//    
//    var isDragging: Bool {
//        switch self {
//        case .inactive:
//            return false
//        case .dragging:
//            return true
//        }
//    }
//}
