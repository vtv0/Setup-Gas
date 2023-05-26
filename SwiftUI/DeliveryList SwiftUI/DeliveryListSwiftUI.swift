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
    //    @State private var selectedStatus = "Not_Delivery"
    @State private var selectedStatus: Int = 0
    
    var car: [String] = []
    //    @State private var selectedCar = "Car1"
    @State private var selectedDriver: Int = 0
    @State private var indxes: [Int] = []
    
    
    @State var listDateString: [String] = []
    @State private var listDay: [Date] = []
    @State private var selectedDate = Date()
    
    @State private var dicData: [Date: [Location]] = [:]
    @State private var listLocation: [Location] = []
    
    @State var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var showSheet = false
    
    @State private var isActivityIndicator = false
    
    @State private var number50kg = 0
    @State private var number30kg = 0
    @State private var number25kg = 0
    @State private var number20kg = 0
    @State private var other = 0
    
    @State private var typeGas = 0
    @State private var countGas = 0
    
    @State private var listImage: [String] = []
    
    @State private var notes: String = ""
    
    @State private var listImageSwiftUI: [UIImage] = []
    
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
                        .onChange(of: selectedStatus) { istatus in
                            print(istatus)
                            listLocation = getDataFiltered(date: selectedDate, driver: selectedDriver, status: istatus)
                        }
                        
                        
                        Picker("", selection: $selectedDriver) {
                            if !indxes.isEmpty {
                                ForEach(Array(zip(indxes.indices, indxes)), id: \.0) { (ind, car)  in
                                    Text("Car\(ind+1)" )
                                }
                                
                            } else  {
                                Text("Car1")
                            }
                        }
                        .pickerStyle(.wheel)
                        .border(.black)
                        .cornerRadius(3)
                        .onChange(of: selectedDriver) { idriver in
                            listLocation = getDataFiltered(date: selectedDate, driver: idriver, status: selectedStatus)
                        }
                        
                        
                        Picker("", selection: $selectedDate) {
                            // convert Date in String
                            ForEach(self.listDay, id: \.self) { idate in
                                // convert date in String
                                let stringDate = convertDateToString(idate: idate.removeTimeStamp!)
                                Text("\(stringDate)")
                            }
                        }
                        .onChange(of: selectedDate) { idate in
                            //                            listLocation = dicData[idate] ?? []
                            listLocation = getDataFiltered(date: idate, driver: 0, status: 0)
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
                            Text("50kg")
                            Text("\(number50kg)")
                        }
                        .frame(maxWidth: .infinity)
                        .border(.black)
                        
                        VStack {
                            Text("30kg")
                            Text("\(number30kg)")
                        }
                        .frame(maxWidth: .infinity)
                        .border(.black)
                        
                        VStack {
                            Text("25kg")
                            Text("\(number25kg)")
                        }
                        .frame(maxWidth: .infinity)
                        .border(.black)
                        
                        VStack {
                            Text("20kg")
                            Text("\(number20kg)")
                        }
                        .frame(maxWidth: .infinity)
                        .border(.black)
                        
                        VStack {
                            Text("other")
                            Text("\(other)")
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
                            // floating panel
                            func callApi()

                        }
                    
                        .sheet(isPresented: $showSheet) {  // Floating panel
                            
                            TabView {
                                ForEach(self.listLocation, id: \.self)  { ilocation in
                                    
                                    VStack {
                                        ScrollView(showsIndicators: false) {
                                            VStack(spacing: 5) { //  to remove spacing between rows
                                                //                                            ForEach(1..<6) { i in
                                                VStack(alignment: .leading) {
                                                    if ilocation.type == .supplier {
//                                                       print("fffffffff")
                                                    } else {
                                                        
                                                        Text(ilocation.elem?.location?.comment ?? "")
                                                            .padding(.top, 15)
                                                        Text(ilocation.asset?.properties?.values.customer_name ?? "")
                                                        Text(ilocation.asset?.properties?.values.address ?? "")
                                                        
                                                        if let minutes = ilocation.elem?.arrivalTime?.minutes,
                                                           let hours = ilocation.elem?.arrivalTime?.hours {
                                                            if minutes < 10 {
                                                                Text("Estimate Time : \(hours):0\(minutes)")
                                                            } else {
                                                                Text("Estimate Time : \(hours):\(minutes)")
                                                            }
                                                        }
                                                       
                                                        
                                                        Button(action: {
                                                            print("open map")
                                                        }) {
                                                            Label("Map", image: "ic_launch_app")
                                                        }
                                                        //                                                        Divider()
                                                    }
                                                }
                                                .frame(maxWidth: .infinity)
                                                .background(Color.yellow)
                                                
                                                // page Image
                                                // page
                                                VStack {
                                                    // truyen UIViewImage -> ViewImageSwiftUI
                                                    let viewImage: UIImageView!
                                                    var urlImage: [String] = ilocation.urls()
//
                                                    ForEach(of: urlImage) { iurl in
                                                        viewImage.downloaded(from: iurl)
                                                        listImageSwiftUI.append(viewImage)
                                                    }
                                                    
//                                                    ViewImageSwiftUI1(elementsImageSwiftUI: listImageSwiftUI)
                                                }
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 350)
                                                .background(Color.gray)

                                                
                                                VStack {
                                                    HStack {
                                                        Spacer()
                                                        Text("Type")
                                                        Spacer()
                                                        
                                                        Spacer()
                                                        Text("Count")
                                                        Spacer()
                                                    }
                                                    // pass data Facility
                                                    ViewTypeAndCount()
                                           
                                                    
                                                } .frame(maxHeight: 350)
                                                    .background(Color.red)
                                                
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        Text("Note")
                                                        
                                                        Spacer()
                                                        Button(action: {
                                                            print("rrrrrrrrr")
                                                        }) {
                                                            Image("ic_edit")
                                                        }
                                                        
                                                    }
                                                    .padding( .horizontal, 10)
                                                    TextField("Hiện ra khi không có ghi chú nào ? ?? ??? ???? ", text: $notes)
                                                    
                                                }
                                                
                                                VStack {
                                                    Text("Estimate Time")
                                                        .font(.system(size: 23))
                                                    Text(ilocation.elem?.metadata?.planned_date ?? "")
                                                        .font(.system(size: 20))
                                                }
                                                
                                                .frame(maxWidth: .infinity, maxHeight: 200)
                                                .background(Color.green)
                                                .border(.black)
                                                .cornerRadius(18)
                                                
                                                // }
                                            }
                                            .padding(.horizontal, 10)
                                        }
                                        
                                        
                                    }
                                    
                                }
                            }
                            
                            .background(Color.clear)
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .presentationDetents([.custom(CustomSheets.self), .height(650)])
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
    
    func convertDateToString(idate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let dateString: String = formatter.string(from: idate)
        return dateString
    }
    
    
    func getDataFiltered(date: Date, driver: Int, status: Int) -> [Location] {
        indxes = []
        var locations: [Location] = []
        var locationsByDriver: [Int: [Location]] = [:]
        var elemLocationADay = [Location]()
        var dataOneDate: [Location] = dicData[date.removeTimeStamp!] ?? []
        
        if dataOneDate.count > 0 && dataOneDate[0].type == .supplier && dataOneDate[0].elem?.locationOrder == 1 {
            dataOneDate.remove(at: 0)
        }
        dataOneDate.forEach() { idataADay in
            elemLocationADay.append(idataADay)
        }
        locations = elemLocationADay
        print(locations)
        
        elemLocationADay.enumerated().forEach { vehicleIdx, vehicle in
            if (vehicle.elem?.location?.locationType?.rawValue == "supplier") {
                indxes.append(vehicleIdx)
            }
        }
        
        indxes.enumerated().forEach { idx, item in
            if Array(elemLocationADay).count > 0 {
                if idx == 0 && indxes[0] > 0 {
                    locationsByDriver[idx] = Array(elemLocationADay[0...indxes[idx]])
                } else if indxes[idx-1]+1 < indxes[idx] {
                    locationsByDriver[idx] = Array(elemLocationADay[indxes[idx-1]+1...indxes[idx]])
                }
            }
        }
        self.selectedDriver = driver
        self.selectedStatus = status
        
        if driver+1 < indxes.count+1 {
            var dataStatus: [Location] = locationsByDriver[driver] ?? []
            
            for statusShipping in dataStatus {
                if statusShipping.elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .waiting
                    && statusShipping.elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .failed &&
                    statusShipping.elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .inprogress {
                    
                    dataStatus.removeAll()
                    dataStatus.append(statusShipping)
                    listLocation = dataStatus
                } else {
                    listLocation = dataStatus
                }
            }
            
            //            self.totalType()
            
        } else if driver+1 == indxes.count+1 {
            var dataStatus: [Location] = dataOneDate
            for statusShipping in dataOneDate {
                if statusShipping.elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .waiting
                    && statusShipping.elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .failed &&
                    statusShipping.elem?.location?.metadata?.display_data?.valueDeliveryHistory() == .inprogress {
                    
                    dataStatus.removeAll()
                    dataStatus.append(statusShipping)
                    listLocation = dataStatus
                } else {
                    listLocation = dataStatus
                }
            }
            //            self.pickerStatus.reloadAllComponents()
            
            
            
        }
        //        customFloatingPanel()
        
        self.totalType_SwiftUI()
        
        
        return listLocation
    }
    
    
    func callApi() {
        Task {
            sevenDay()
            do {
                // getMe
                let companyCode = UserDefaults.standard.string(forKey: "companyCode") ?? ""
                let responseGetMe_SwiftUI = try await GetMe_Async_Await().getMe_Async_Await(companyCode: companyCode, token: UserDefaults.standard.string(forKey: "accessToken") ?? "")
                print(responseGetMe_SwiftUI)
                do {
                    // getWorkerRouteLocationList_Async_Await()
                    let dicDataResponse_SwiftUI = await GetWorkerRouteLocationList_Async_Await().loadDic(dates: listDay)
                    dicData = dicDataResponse_SwiftUI
                    showSheet = true
                    isActivityIndicator = false
                    
                    //creata list listLocationLocation
                    //                                        listLocation = dicData[selectedDate.removeTimeStamp!] ?? []
                    listLocation = getDataFiltered(date: selectedDate, driver: selectedDriver, status: selectedStatus)
                    
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
    
    func totalType_SwiftUI() {
        var arrFacilityData: [[Facility_data]] = []
        var numberType50: Int = 0
        var numberType30: Int = 0
        var numberType25: Int = 0
        var numberType20: Int = 0
        var numberTypeOther: Int = 0
        for facilityData in listLocation {
            arrFacilityData.append(facilityData.elem?.metadata?.facility_data ?? [])
            
        }
        for iFacilityData in arrFacilityData {
            for detailFacilityData in iFacilityData {
                if detailFacilityData.type == 50 {
                    numberType50 = numberType50 + (detailFacilityData.count ?? 0)
                } else if detailFacilityData.type == 30 {
                    numberType30 = numberType30 + (detailFacilityData.count ?? 0)
                } else if detailFacilityData.type == 25 {
                    numberType25 = numberType25 + (detailFacilityData.count ?? 0)
                } else if detailFacilityData.type == 20 {
                    numberType20 = numberType20 + (detailFacilityData.count ?? 0)
                } else {
                    numberTypeOther = numberTypeOther + (detailFacilityData.count ?? 0)
                }
                
            }
        }
        self.number50kg = numberType50
        self.number30kg = numberType30
        self.number25kg = numberType25
        self.number20kg = numberType20
        self.other = numberTypeOther
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


//struct ViewImageSwiftUI1: View {
//    @Binding var elementsImageSwiftUI: [UIImage]
//    var body: some View {
//        TabView {
//            ForEach(elementsImageSwiftUI, id: \.self) { iImageSwiftUI in
//                Image(uiImage: iImageSwiftUI)
//            }
//        }
//        .tabViewStyle(.page)
//        .background(Color.gray)
//    }
//}
