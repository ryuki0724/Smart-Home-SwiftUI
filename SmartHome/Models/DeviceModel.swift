//
//  DeviceModel.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/1.
//

import Foundation
import Combine

class DeviceModel: Identifiable, ObservableObject {
    @Published var id:     Int
    @Published var roomId: Int
    @Published var type:   String
    @Published var brand:  String
    @Published var icon:   String
    @Published var status: Int
    @Published var mac:    String
    
    init(id: Int = 0, roomId: Int = 0, type: String = "", brand: String = "", icon: String = "", status: Int = 0, mac: String = "") {
        self.id     = id
        self.roomId = roomId
        self.type   = type
        self.brand  = brand
        self.icon   = icon
        self.status = status
        self.mac    = mac
    }
    
    struct Response: Decodable {
        let status: String
        let message: String
        let devices: [Device]?
        
        struct Device: Decodable {
            let id: Int
            let roomId: Int
            let type: String
            let brand: String
            let icon: String
            let status: Int
            let mac: String
        }
    }
    
    // 獲取所有設備（不限房間）
    static func getAll(houseId: Int, completion: @escaping ([DeviceModel]) -> Void) {
        let requestData: [String: Any] = ["houseId": houseId]
        WebSocketManager.shared.sendRequest(request: "device", action: "getAll", data: requestData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion([])
                return
            }
            
            let devices = response.devices?.map { device in
                DeviceModel(id: device.id, roomId: device.roomId, type: device.type, brand: device.brand, icon: device.icon, status: device.status, mac: device.mac)
            } ?? []
            completion(devices)
        }
    }
    
    // 獲取特定房間的設備
    static func getByRoom(roomId: Int, completion: @escaping ([DeviceModel]) -> Void) {
        let requestData: [String: Any] = ["roomId": roomId]
        WebSocketManager.shared.sendRequest(request: "device", action: "getByRoom", data: requestData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion([])
                return
            }
            
            let devices = response.devices?.map { device in
                DeviceModel(id: device.id, roomId: device.roomId, type: device.type, brand: device.brand, icon: device.icon, status: device.status, mac: device.mac)
            } ?? []
            completion(devices)
        }
    }
    
    // 添加設備
    //    func add(completion: @escaping (Bool) -> Void) {
    //        let addData: [String: Any] = ["roomId": self.roomId, "type": self.type, "brand": self.brand, "icon": self.icon, "status": self.status, "mac": self.mac]
    //        WebSocketManager.shared.sendRequest(request: "device", action: "add", data: addData) { (response: Response?) in
    //            guard let response = response, response.status == "success" else {
    //                completion(false)
    //                return
    //            }
    //            self.id = response.devices.first?.id ?? 0
    //            completion(true)
    //        }
    //    }
    
    func add(roomId: Int, productId: Int, icon: String, mac: String, completion: @escaping (Bool) -> Void) {
        let addData: [String: Any] = ["roomId": roomId, "productId": productId, "icon": icon, "mac": mac]
        WebSocketManager.shared.sendRequest(request: "device", action: "add", data: addData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // 保存設備數據
    func save(completion: @escaping (Bool) -> Void) {
        let saveData: [String: Any] = ["id": self.id, "roomId": self.roomId, "type": self.type, "brand": self.brand, "icon": self.icon, "status": self.status, "mac": self.mac]
        WebSocketManager.shared.sendRequest(request: "device", action: "save", data: saveData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // 刪除設備
    func delete(completion: @escaping (Bool) -> Void) {
        let deleteData: [String: Any] = ["id": self.id]
        WebSocketManager.shared.sendRequest(request: "device", action: "delete", data: deleteData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // 控制設備狀態
    func changeStatus(userId: Int, mac: String, status: Int, completion: @escaping (Bool) -> Void) {
        let controlData: [String: Any] = [
            "type": "infrared",
            "action": [
                "type": "send",
                "action": (status != 0) ? "light_on" : "light_off"
            ],
            "data": [
                "userId": userId,
                "mac": mac,
                "status": status
            ]
        ]
        
        WebSocketManager.shared.sendRequest(request: "device", action: "changeStatus", data: controlData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion(false)
                return
            }
//            self.status = status
            completion(true)
        }
    }
}
