//
//  UISheetSwiftUI.swift
//  Gas
//
//  Created by Vuong The Vu on 16/05/2023.
//

import SwiftUI



public extension View {
    func sheetPresentation<SheetView: View>(isPresented: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView, onDismiss: SheetPresentationController<SheetView>.DefaultClosureType? = nil) -> some View {
        
        self.background(
            SheetPresentationController(isPresented: isPresented, sheetView: sheetView(), onDismiss: onDismiss)
        )
    }
}

public struct SheetPresentationController<SheetView: View>: UIViewControllerRepresentable {
    
    public typealias DefaultClosureType = () -> ()
    
    private let viewController = UIViewController()
    
    @Binding var isPresented: Bool
    var sheetView: SheetView
    var onDismiss: DefaultClosureType?
    
    public init(isPresented: Binding<Bool>, sheetView: SheetView, onDismiss: DefaultClosureType?) {
        self._isPresented = isPresented
        self.sheetView = sheetView
        self.onDismiss = onDismiss
    }
    
    public func makeCoordinator() -> Coordinator {
        
        return Coordinator(parent: self)
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        
        viewController.view.backgroundColor = .gray
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        if isPresented {
            
            if uiViewController.presentedViewController == nil {
                
                let sheetViewController = CustomSheetHostingViewController(rootView: sheetView)
                
                sheetViewController.sheetPresentationController?.delegate = context.coordinator
                sheetViewController.delegate = context.coordinator
                
                uiViewController.present(sheetViewController, animated: true)
            }
        } else {
            
            uiViewController.dismiss(animated: true)
        }
    }
    
    public class Coordinator: NSObject, UISheetPresentationControllerDelegate, CustomSheetHostingViewControllerDelegate {
        
        var parent: SheetPresentationController
        
        init(parent: SheetPresentationController) {
            self.parent = parent
        }
        
        public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            
            if self.parent.isPresented {
                
                self.parent.isPresented = false
                
                if let onDismiss = self.parent.onDismiss {
                    onDismiss()
                }
            }
        }
        
        fileprivate func sheetViewControllerDidDisappear<Content>(_ sheetViewController: CustomSheetHostingViewController<Content>) where Content : View {
            
            self.parent.isPresented = false
            
            if let onDismiss = self.parent.onDismiss {
                onDismiss()
            }
        }
    }
}


///////////////////

private protocol CustomSheetHostingViewControllerDelegate: AnyObject {
    func sheetViewControllerDidDisappear<Content: View>(_ sheetViewController: CustomSheetHostingViewController<Content>)
}

private class CustomSheetHostingViewController<Content: View>: UIHostingController<Content> {
    
    weak var delegate: CustomSheetHostingViewControllerDelegate?
    
    override func viewDidLoad() {
        
        view.backgroundColor = .blue
        
        if let sheetPresentationController = self.sheetPresentationController {
            
            sheetPresentationController.detents = [.medium(), .large()]
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
            sheetPresentationController.preferredCornerRadius = 20
            //            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.sheetViewControllerDidDisappear(self)
    }
}


// MARK: - Preview

struct SheetPresentationController_Previews: PreviewProvider {
    
    struct SheetPresentationControllerExampleView : View {
        
        @State private var showSheet: Bool = false
        
        var body: some View {
            
            NavigationView {
                
                Button {
                                        showSheet.toggle()
//                    showSheet = true
                } label: {
                    Text("hien thi mot nua man hinh")
                }
                .navigationTitle("Half Sheet")
                .sheetPresentation(isPresented: $showSheet, sheetView: {
                    Color.red
                        .edgesIgnoringSafeArea(.all)
                }, onDismiss: {
                    
                })
            }
        }
    }
    
    static var previews: some View {
        
        SheetPresentationControllerExampleView()
    }
}

