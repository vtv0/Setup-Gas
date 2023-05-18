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
    
    
    var status: [String] = ["Not_Delivery", "All"]
    @State private var selectedStatus = "Not_Delivery"
    var car: [String] = ["Car1", "Car2", "Car3"]
    @State private var selectedCar = "Car1"
    @State var listDateString: [String] = []
    @State private var listDay: [Date] = []
    @State private var selectedDate = ""
    
    @State private var dicData: [Date: [Location]] = [:]
    
    @State var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var showSheet = false
    
    @State private var isActivityIndicator = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $coordinateRegion)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
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
                    .border(.black)
                    .background(Color.yellow)
                    
                    //                    Spacer()
                    
                    HStack(alignment: .top) {
                        VStack {
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
                    .background(Color.white)
                    .border(.black)
                    
                    
                    .navigationBarTitle("Delivery List SwiftUI")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.cyan, for: .navigationBar)
                    
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
                    } .toolbarRole(.navigationStack)
                    
                        .onAppear {
                            isActivityIndicator = true
                            sevenDay()
                            convertDateToString()
                            
                            // floating panel
                            
                            Task {
                                do {
                                    // getMe
                                    let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
                                    let responseGetMe_SwiftUI = try await GetMe_Async_Await().getMe_Async_Await(companyCode: companyCode, token: UserDefaults.standard.string(forKey: "accessToken") ?? "")
                                    print(responseGetMe_SwiftUI)
                                    do {
                                        // getLast...
                                        let dicDataResponse_SwiftUI = await GetWorkerRouteLocationList_Async_Await().loadDic(dates: listDay)   //.getWorkerRouteLocationList_Async_Await()
                                        dicData = dicDataResponse_SwiftUI
                                        showSheet = true
                                        isActivityIndicator = false
                                        print(dicData)
                                        
                                    }
                                    
                                } catch {
                                    if let err = error as? GetMe_Async_Await.AFError {
                                        if err == .tokenOutOfDate {
                                            //  hideActivity()
                                            //  let scr = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                                            //  self.navigationController?.pushViewController(scr, animated: true)
                                            //  showAlert(message: "Token đã hết hạn -> Login lại")
                                        } else if err == .remain {
                                            // hideActivity()
                                            // showAlert(message: "Có lỗi xảy ra")
                                        }
                                    }
                                }
                                
                            }
                        }
                    
                        .sheet(isPresented: $showSheet) {    // Floating panel
                            
                            TabView {
//                                for iLocation in Location
                              
                                Text("1")
                                Text("2")
                                Text("3")
                                Text("4")
                                Text("5")
                                
                                VStack {
                                    ScrollView(showsIndicators: false) {
                                        VStack(spacing: 5) { //  to remove spacing between rows
                                            ForEach(1..<3) { i in
                                                ZStack{
                                                    Text(String(i))
                                                    Circle()
                                                } .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                                    .background(Color.yellow)
                                            }
                                            
                                        }
                                    }
//                                    .onAppear {
//                                        UIScrollView.appearance().isPagingEnabled = true
//                                    }
//                                    .onDisappear {
//                                        UIScrollView.appearance().isPagingEnabled = false
//                                    }
                                }
                                
                                
                            }
                            .background(Color.blue)
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            
                            
                            
                            
                            .presentationDetents([ .custom(CustomSheets.self), .height(650)])
                            .interactiveDismissDisabled()
                            .presentationBackgroundInteraction(.enabled)
                            .zIndex(-100)
                        }
                    
                    
                    Button(action: {
                        print("shipping")
                        
                    }) {
                        
                        HStack {
                            
                            Spacer()
                            
                            Text("Shiping")
                                .frame(maxWidth: 250)
                                .frame(height:40)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .tint(Color.white)
                                .zIndex(100)
                            Spacer()
                            
                        }
                        
                    } .frame(maxHeight: .infinity, alignment: .bottom)
                    
                    
                    
                }
                
                if isActivityIndicator {  // show indicator
                    LoadingView()
                }
            }
            
        }
        
        
    }
    
    func sevenDay() {
        let anchor = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for dayOffset in 0...6 {
            if let date1 = calendar.date(byAdding: .day, value: dayOffset, to: anchor)?.removeTimeStamp {
                listDay.append(date1)
            }
        }
    }
    
    func convertDateToString() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        for idate in listDay {
            let dateString: String = formatter.string(from: idate)
            listDateString.append(dateString)
        }
    }
    
}

struct CustomSheets: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        if context.dynamicTypeSize.isAccessibilitySize {
            return 700
        } else {
            return 160
        }
    }
}

struct DeliveryListSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryListSwiftUI()
    }
}


