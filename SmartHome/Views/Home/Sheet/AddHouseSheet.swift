//
//  AddHouseSheet.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/24.
//

import SwiftUI

struct AddHouseSheet: View {
    
    @Binding var isPresented:   Bool
    @Binding var houses:        [HouseModel]
    @Binding var selectedHouse: HouseModel?
    
    @State private var name   = ""
    @State private var remark = ""
    
    var loadRooms: (Int) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("家庭名稱")) {
                    TextField("請輸入家庭名稱", text: $name)
                }
                
                Section(header: Text("備註")) {
                    TextField("請輸入備註(選填)", text: $remark)
                }
            }
            .navigationTitle("新增家庭")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        addNewHouse()
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func addNewHouse() {
        let newHouse = HouseModel(userId: UserModel.shared.id, name: name, remark: remark)
        newHouse.add { success in
            if success {
                HouseModel.getAll(userId: UserModel.shared.id) { fetchedHouses in
                    houses = fetchedHouses
                    if let addedHouse = fetchedHouses.first(where: { $0.name == name }) {
                        selectedHouse = addedHouse
                        loadRooms(addedHouse.id)
                    }
                }
            } else {
                // 處理添加失敗
            }
        }
    }
}

#Preview {
    AddHouseSheet(isPresented: .constant(true), houses: .constant([]), selectedHouse: .constant(nil), loadRooms: { _ in })
}
