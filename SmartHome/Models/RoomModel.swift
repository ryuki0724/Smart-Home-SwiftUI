//
//  RoomModel.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/1.
//

import Foundation

import Foundation
import Combine

class RoomModel: Identifiable, ObservableObject, Hashable {
    @Published var id: Int
    @Published var houseId: Int
    @Published var name: String
    @Published var icon: String
    
    init(id: Int = 0, houseId: Int = 0, name: String = "", icon: String = "") {
        self.id = id
        self.houseId = houseId
        self.name = name
        self.icon = icon
    }
    
    static func == (lhs: RoomModel, rhs: RoomModel) -> Bool {
        return lhs.id == rhs.id && lhs.houseId == rhs.houseId && lhs.name == rhs.name && lhs.icon == rhs.icon
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(houseId)
        hasher.combine(name)
        hasher.combine(icon)
    }
    
    struct Response: Decodable {
        let status: String
        let message: String
        let rooms: [Room]
        
        struct Room: Decodable {
            let id: Int
            let houseId: Int
            let name: String
            let icon: String
        }
    }
    
    // 獲取所有房間
    static func getAll(houseId: Int, completion: @escaping ([RoomModel]) -> Void) {
        let requestData: [String: Any] = ["houseId": houseId]
        WebSocketManager.shared.sendRequest(request: "room", action: "getAll", data: requestData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion([])
                return
            }
            
            let rooms = response.rooms.map { room in
                RoomModel(id: room.id, houseId: room.houseId, name: room.name, icon: room.icon)
            }
            completion(rooms)
        }
    }
    
    // 添加房間
    func add(completion: @escaping (Bool) -> Void) {
        let addData: [String: Any] = ["houseId": self.houseId, "name": self.name, "icon": self.icon]
        WebSocketManager.shared.sendRequest(request: "room", action: "add", data: addData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion(false)
                return
            }
            self.id = response.rooms.first?.id ?? 0
            completion(true)
        }
    }
    
    // 保存房間數據
    func save(completion: @escaping (Bool) -> Void) {
        let saveData: [String: Any] = ["id": self.id, "houseId": self.houseId, "name": self.name, "icon": self.icon]
        WebSocketManager.shared.sendRequest(request: "room", action: "save", data: saveData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // 刪除房間
    func delete(completion: @escaping (Bool) -> Void) {
        let deleteData: [String: Any] = ["id": self.id]
        WebSocketManager.shared.sendRequest(request: "room", action: "delete", data: deleteData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
