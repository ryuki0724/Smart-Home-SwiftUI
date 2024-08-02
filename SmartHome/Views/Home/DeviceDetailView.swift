//
//  DeviceDetailView.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/15.
//

import SwiftUI

struct DeviceDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showActionSheet = false
    var device: DeviceModel
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("設備詳情")) {
                    Text("設備類型: \(device.type)")
                    Text("品牌: \(device.brand)")
                    Text("狀態: \(device.status == 1 ? "開啟" : "關閉")")
                    
                    // 預留控制按鈕位置
                    //Button("控制設備") {
                    //    // 控制設備操作
                    //}
                }
                Section("設備") {
                    Button("移除設備") {
                        showActionSheet = true
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("確認移除"),
                message: Text("你確定要移除這個設備嗎？"),
                buttons: [
                    .destructive(Text("確認移除")) {
                        deleteDevice()
                    },
                    .cancel(Text("取消"))
                ]
            )
        }
        .navigationBarTitle("設備詳情", displayMode: .inline)
    }
    
    private func deleteDevice() {
        device.delete { success in
            if success {
                presentationMode.wrappedValue.dismiss()
                print("設備刪除成功")
            } else {
                // Handle failure (e.g., show an error message)
                print("設備刪除失敗")
            }
        }
    }
}

#Preview {
    DeviceDetailView(device: DeviceModel(id: 1, roomId: 1, type: "電燈", brand: "三星", icon: "lamp.floor.fill", status: 0, mac: "00:11:22:33:44:55"))
}
