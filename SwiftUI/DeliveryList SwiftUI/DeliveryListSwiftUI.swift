//
//  DeliveryListSwiftUI.swift
//  Gas
//
//  Created by Vuong The Vu on 05/05/2023.
//

import SwiftUI

struct DeliveryListSwiftUI: View {
    var status: [String] = [ "Not_Delivery", "All"]
    @State private var selectedStatus = "Not_Delivery"
    
    var car: [String] = ["Car1", "Car2", "Car3"]
    @State private var selectedCar = "Car1"
    
    var listDay: [Date] = []
    var listDateString: [String] = []
    @State private var selectedDate = ""

    
    var body: some View {
        NavigationStack {
        
                HStack {
                    
                    Picker("", selection: $selectedStatus) {
                        ForEach(status, id: \.self) { status in
                            Text("\(status)")
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Picker("", selection: $selectedCar) {
                        ForEach(car, id: \.self) { car in
                            Text("\(car)" )
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    //                    Picker("", selection: $selectedDate) {
                    //                        // convert Date in String
                    //                        ForEach(listDateString, id: \.self) {
                    //                            Text($0)
                    //                        }
                    //                    }
                    //                    .pickerStyle(.wheel)
                }
                
            }
               
                .navigationTitle("Delivery List")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        
                        Button(action: {
                            print("reroute")
                        }) {
                            Image("ic_line")
                        }
                        
                        
                        Button(action: {
                            print("reroute")
                        }) {
                            Image("point")
                        }
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("setting")
                        }) {
                            Image("ic_setting")
                            
                        }
                    }
                }
            
                .background(.yellow)
                .frame(height: 60)
                .padding(.top, 2)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.cyan, for: .navigationBar)
//                .safeAreaInset(edge: .top) {}
                .alignmentGuide(.bottom, computeValue: { d in
                    d.height
                })
        }
    
    
}



struct DeliveryListSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        
        DeliveryListSwiftUI()
    }
}
