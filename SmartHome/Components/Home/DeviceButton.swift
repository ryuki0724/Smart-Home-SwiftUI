//
//  DeviceButton.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/12.
//

import SwiftUI

struct DeviceButton: View {
    @Binding var userId: Int
    @ObservedObject var device: DeviceModel
    
    var changeStatus: (Int, String, Int, @escaping (Bool) -> Void) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: device.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.blue)
                
                Spacer()
                
                // 包裝 Toggle 以防止觸發 NavigationLink
                Button(action: {
                    device.status = device.status == 1 ? 0 : 1
                    changeStatus(device.id, device.mac, device.status) { success in
                        if !success {
                            device.status = device.status == 1 ? 0 : 1
                        }
                    }
                }) {
                    Toggle("", isOn: Binding<Bool>(
                        get: { device.status == 1 },
                        set: { device.status = $0 ? 1 : 0 }
                    ))
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                .buttonStyle(PlainButtonStyle())  // 防止 Button 的樣式改變
            }
            .frame(height: 40)
            
            VStack {
                Spacer()
                
                Group {
                    Text(device.type)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(device.brand)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .frame(height: 130)
        .background(Color("ButtonColor"))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    DeviceButton(
        userId: .constant(1),
        device: DeviceModel(id: 1, roomId: 1, type: "電燈", brand: "三星", icon: "lamp.floor.fill", status: 0, mac: "00:11:22:33:44:55"),
        changeStatus: { _, _, _, _ in }
    )
}
