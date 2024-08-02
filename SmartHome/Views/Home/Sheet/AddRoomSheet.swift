//
//  AddRoomSheet.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/24.
//

import SwiftUI
import SFSymbolsPicker

struct AddRoomSheet: View {
    
    @Binding var isPresented:   Bool
    @Binding var rooms:         [RoomModel]
    @Binding var selectedRoom:  RoomModel?
    @Binding var selectedHouse: HouseModel?
    
    @State private var name           = ""
    @State private var selectedIcon   = "house.fill"
    @State private var showIconPicker = false
    
    var loadDevicesByRoom: (Int) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("房間名稱")) {
                    TextField("請輸入房間名稱", text: $name)
                }
                
                Section(header: Text("圖標")) {
                    HStack {
                        Image(systemName: selectedIcon)
                        Text(selectedIcon)
                        Spacer()
                        Button(action: {
                            showIconPicker.toggle()
                        }) {
                            Image(systemName: "square.grid.2x2")
                        }
                    }
                }
            }
            .navigationTitle("新增房間")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        addNewRoom()
                        isPresented = false
                    }
                }
            }
            .sheet(isPresented: $showIconPicker) {
                SymbolsPicker(selection: $selectedIcon, title: "選擇圖標", autoDismiss: true)
            }
        }
    }
    
    private func addNewRoom() {
        guard let houseId = selectedHouse?.id else { return }
        let newRoom = RoomModel(houseId: houseId, name: name, icon: selectedIcon)
        newRoom.add { success in
            if success {
                RoomModel.getAll(houseId: houseId) { fetchedRooms in
                    rooms = fetchedRooms
                    if let addedRoom = fetchedRooms.first(where: { $0.name == name }) {
                        selectedRoom = addedRoom
                        loadDevicesByRoom(addedRoom.id)
                    }
                }
            } else {
                // 處理添加失敗
            }
        }
    }
}

#Preview {
    AddRoomSheet(isPresented: .constant(true), rooms: .constant([]), selectedRoom: .constant(nil), selectedHouse: .constant(HouseModel(id: 1, name: "家庭1")), loadDevicesByRoom: { _ in })
}
