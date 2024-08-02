// //
// //  AddDevice.swift
// //  SmartHome
// //
// //  Created by 吉田龍生 on 2024/5/20.
// //

// import SwiftUI

// struct AddDevice: View {
//   @Environment(\.presentationMode) var presentationMode
//   var device: DeviceModel
  
//   @State private var selectedBrand: String = ""
//   @State private var category: String = ""
//   @State private var notes: String = ""
  
//   let brands = ["三星", "LG", "Sony", "Panasonic", "Philips", "自主品牌"]
//   let categories = ["燈光", "家電", "安全", "遙控器", "其他"]
  
//   var body: some View {
//       NavigationStack {
//           Form {
//               Section(header: Text("廠牌")) {
//                   Picker("選擇廠牌", selection: $selectedBrand) {
//                       ForEach(brands, id: \.self) {
//                           Text($0)
//                       }
//                   }
//                   .pickerStyle(MenuPickerStyle())
//               }
              
//               Section(header: Text("類別")) {
//                   Picker("選擇類別", selection: $category) {
//                       ForEach(categories, id: \.self) {
//                           Text($0)
//                       }
//                   }
//                   .pickerStyle(MenuPickerStyle())
//               }
              
//               Section(header: Text("備註")) {
//                   TextField("備註", text: $notes)
//               }
//           }
//           .navigationTitle("設備詳情")
//           .toolbar {
//               ToolbarItem(placement: .navigationBarLeading) {
//                   Button("取消") {
//                       presentationMode.wrappedValue.dismiss()
//                   }
//               }
//               ToolbarItem(placement: .navigationBarTrailing) {
//                   Button("保存") {
//                       // 保存設備詳情的代碼可以放在這裡
//                       presentationMode.wrappedValue.dismiss()
//                   }
//               }
//           }
//       }
//       .onAppear {
//           selectedBrand = device.brand
//           category = categories.first ?? ""
//       }
//   }
// }

// #Preview {
//   AddDevice(device: DeviceModel(id: 1, icon: "antenna.radiowaves.left.and.right", status: false, deviceType: "ESP32", brand: "Device 1"))
// }
