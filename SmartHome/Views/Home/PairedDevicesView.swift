// //
// //  PairedDevicesView.swift
// //  SmartHome
// //
// //  Created by 吉田龍生 on 2024/5/19.
// //

// import SwiftUI

// struct PairedDevicesView: View {
//    @Binding var selectedDevice: DeviceModel?
//    @Binding var showPairDeviceSheet: Bool
//    @Binding var showAddDeviceSheet: Bool
   
//    @State private var devices: [DeviceModel] = [
//        DeviceModel(id: 1, icon: "antenna.radiowaves.left.and.right", status: false, deviceType: "ESP32", brand: "Device 1"),
//        DeviceModel(id: 2, icon: "antenna.radiowaves.left.and.right", status: false, deviceType: "ESP32", brand: "Device 2"),
//        DeviceModel(id: 3, icon: "antenna.radiowaves.left.and.right", status: false, deviceType: "ESP32", brand: "Device 3")
//    ]
   
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(devices) { device in
//                    Button(action: {
//                        selectedDevice = device
//                        showPairDeviceSheet = false
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                            showAddDeviceSheet = true
//                        }
//                    }) {
//                        HStack {
//                            Image(systemName: device.icon)
//                            Text("\(device.deviceType) - \(device.brand)")
//                        }
//                    }
//                }
//            }
//            .navigationTitle("配對設備")
//        }
//    }
// }

// #Preview {
//    PairedDevicesView(selectedDevice: .constant(nil), showPairDeviceSheet: .constant(true), showAddDeviceSheet: .constant(false))
// }
