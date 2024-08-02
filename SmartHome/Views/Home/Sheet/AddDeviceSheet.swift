//
//  AddDeviceSheet.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/24.
//

import SwiftUI

struct AddDeviceSheet: View {
    @ObservedObject var deviceModel = DeviceModel()
    
    @State private var scannedCode: String? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showRoomSelection = false
    @State private var tempSelectedRoom: RoomModel?
    
    @Binding var selectedRoom: RoomModel?
    @Binding var isPresented: Bool
    
    var refreshDevices: () -> Void
    var rooms: [RoomModel]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("將攝像頭對準 QR Code 以掃描配對")
                    .font(.headline)
                    .padding()
                
                QRCodeScanner(scannedCode: $scannedCode, isPresented: $isPresented)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .onChange(of: scannedCode) {
                        if let code = scannedCode {
                            if selectedRoom == nil {
                                if rooms.isEmpty {
                                    alertMessage = "您還沒有房間，請先新增房間。"
                                    showAlert = true
                                } else {
                                    showRoomSelection = true
                                }
                            } else {
                                parseAndAddDevice(from: code)
                            }
                        }
                    }
            }
            .navigationBarTitle("加入配件", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("錯誤"), message: Text(alertMessage), dismissButton: .default(Text("確認"), action: {
                    scannedCode = nil
                }))
            }
            .sheet(isPresented: $showRoomSelection) {
                NavigationStack {
                    Form {
                        VStack {
                            Picker("選擇房間", selection: $tempSelectedRoom) {
                                ForEach(rooms, id: \.self) { room in
                                    Text(room.name).tag(room as RoomModel?)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .padding()
                        }
                    }
                    .background(Color.gray.opacity(0.2)) // 設置背景顏色
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("取消") {
                                showRoomSelection = false
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("確認") {
                                if let selectedRoom = tempSelectedRoom {
                                    self.selectedRoom = selectedRoom
                                    if let code = scannedCode {
                                        parseAndAddDevice(from: code)
                                    }
                                }
                                showRoomSelection = false
                            }
                        }
                    }

                }
                .presentationDetents([.fraction(0.5)])
            }
        }
    }
    
    private func parseAndAddDevice(from code: String) {
        if let deviceInfo = parseQRCode(code) {
            guard let roomId = selectedRoom?.id else { return }
            addDevice(roomId: roomId, productId: deviceInfo.productId, icon: deviceInfo.icon, mac: deviceInfo.mac)
        } else {
            alertMessage = "這是錯誤的 QR Code"
            showAlert = true
        }
    }
    
    private func addDevice(roomId: Int, productId: Int, icon: String, mac: String) {
        deviceModel.add(roomId: roomId, productId: productId, icon: icon, mac: mac) { success in
            DispatchQueue.main.async {
                print("Add device callback received: \(success)")
                if success {
                    print("設備添加成功")
                    isPresented = false
                    refreshDevices()
                } else {
                    print("設備添加失敗")
                }
            }
        }
    }
    
    private func parseQRCode(_ code: String) -> (productId: Int, icon: String, mac: String)? {
        if let data = code.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let productIdString = json["productId"] as? String, let productId = Int(productIdString),
                   let icon = json["icon"] as? String, let mac = json["mac"] as? String {
                    return (productId, icon, mac)
                }
            } catch {
                print("無法解析 QR Code: \(error)")
                alertMessage = "無法解析 QR Code: \(error.localizedDescription)"
                showAlert = true
            }
        }
        return nil
    }
}

#Preview {
    AddDeviceSheet(selectedRoom: .constant(nil), isPresented: .constant(true), refreshDevices: {}, rooms: [])
}
