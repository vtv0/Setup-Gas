//
//  DeliveryListSwiftUI.swift
//  Gas
//
//  Created by Vuong The Vu on 05/05/2023.
//

import SwiftUI
import CoreLocation
import MapKit

struct DeliveryListSwiftUI: View {
    
    var status: [String] = [ "Not_Delivery", "All"]
    @State private var selectedStatus = "Not_Delivery"
    
    var car: [String] = ["Car1", "Car2", "Car3"]
    @State private var selectedCar = "Car1"
    
    var listDay: [Date] = []
    var listDateString: [String] = ["11/05", "12/05", "13/05"]
    @State private var selectedDate = ""
    
    
    @State var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        
        NavigationStack {
         
            HStack(alignment: .top) {
                Picker("", selection: $selectedStatus) {
                    ForEach(status, id: \.self) { status in
                        Text("\(status)")
                    }
                }
                .pickerStyle(.wheel)
                .border(.black)
                .cornerRadius(3)
                
                Picker("", selection: $selectedCar) {
                    ForEach(car, id: \.self) { car in
                        Text("\(car)" )
                    }
                }
                .pickerStyle(.wheel)
                .border(.black)
                .cornerRadius(3)
                
                Picker("", selection: $selectedDate) {
                    // convert Date in String
                    ForEach(listDateString, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.wheel)
                .border(.black)
                .cornerRadius(3)
                
            }
            .frame(height: 45.0)
            .background(Color.gray)
            
            
            HStack(alignment: .top) {
                
                HStack {
                    VStack(alignment: .center) {
                        Label("50kg", image: "")
                        Label("5", image: "")
                    }
                    .frame(maxWidth: .infinity)
                    .border(.black)
                    
                    VStack {
                        Label("30kg", image: "")
                        Label("3", image: "")
                    }
                    .frame(maxWidth: .infinity)
                    .border(.black)
                    
                    VStack {
                        Label("25kg", image: "")
                        Label("2", image: "")
                    }
                    .frame(maxWidth: .infinity)
                    .border(.black)
                    
                    VStack {
                        Label("20kg", image: "")
                        Label("1", image: "")
                    }
                    .frame(maxWidth: .infinity)
                    .border(.black)
                    
                    VStack {
                        Label("other", image: "")
                        Label("0", image: "")
                    }
                    .frame(maxWidth: .infinity)
                    .border(.black)
                    
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
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.cyan, for: .navigationBar)
            
            Map(coordinateRegion: $coordinateRegion)
                .edgesIgnoringSafeArea(.bottom)
//                .frame(width: 400, height: 300)
        }
    }
}

struct DeliveryListSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        
        DeliveryListSwiftUI()
    }
}


