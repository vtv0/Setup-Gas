//
//  DeliveryListSwiftUI.swift
//  Gas
//
//  Created by Vuong The Vu on 05/05/2023.
//

import SwiftUI

struct DeliveryListSwiftUI: View {
    @State private var selectedStrength = "1"
//    @State private var selectrdDate =
    var car: [String] = ["1", "2", "3"]
    var listDay: [Date] = []
    
    var body: some View {
        NavigationStack {
            
//            HStack {
//                .toolbar {
//                    ToolbarItemGroup(placement: .navigationBarLeading) {
//                        
//                        Button(action: {
//                           
//                            print("Replan")
//                        }) {
//                            
//                            Image("ic_edit")
//                                .background(Color.blue)
//                        }
//                        
//                        
//                        Button(action: {
//                            print("reroute")
//                        }) {
//                            Image("point")
//                        }
//                    }
//                    
//                    
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//                            print("setting")
//                        }) {
//                            Image("ic_setting")
//                                .background(Color.red)
//                        }
//                    }
//                }
//            }
            
//            Form {
//                Section {
                   HStack {
                        Picker("Strength", selection: $selectedStrength) {
                            ForEach(car, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Picker("Strength", selection: $selectedStrength) {
                            ForEach(car, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                        
//                        Picker("Strength", selection: .constant()) 
                        .pickerStyle(.wheel)
                    }
//                }
//            }
//            .frame(width: self.view?.bounds.width)
            
            .navigationTitle("Delivery List")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.gray)
            
            
            
           
           
            
            
        }
        .background(Color.cyan)
    }
    
    mutating func sevenDay() {
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor)?.removeTimeStamp {
                self.listDay.append(date1) // error
            }
        }
    }
    
}

    

struct DeliveryListSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryListSwiftUI()
    }
}
