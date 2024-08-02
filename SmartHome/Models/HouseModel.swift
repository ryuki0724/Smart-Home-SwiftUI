//
//  HouseModel.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/1.
//

import Foundation
import Combine

class HouseModel: Identifiable, ObservableObject {
    @Published var id: Int
    @Published var userId: Int
    @Published var name: String
    @Published var remark: String
    
    init(id: Int = 0, userId: Int = 0, name: String = "", remark: String = "") {
        self.id = id
        self.userId = userId
        self.name = name
        self.remark = remark
    }
    
    struct Response: Decodable {
        let status: String
        let message: String
        let houses: [House]
        
        struct House: Decodable {
            let id: Int
            let userId: Int
            let name: String
            let remark: String
        }
    }
    
    // 獲取所有家庭
    static func getAll(userId: Int, completion: @escaping ([HouseModel]) -> Void) {
        let requestData: [String: Any] = ["userId": userId]
        WebSocketManager.shared.sendRequest(request: "house", action: "getAll", data: requestData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion([])
                return
            }
            
            let houses = response.houses.map { house in
                HouseModel(id: house.id, userId: house.userId, name: house.name, remark: house.remark)
            }
            completion(houses)
        }
    }
    
    // 添加家庭
    func add(completion: @escaping (Bool) -> Void) {
        let addData: [String: Any] = ["userId": self.userId, "name": self.name, "remark": self.remark]
        WebSocketManager.shared.sendRequest(request: "house", action: "add", data: addData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion(false)
                return
            }
            self.id = response.houses.first?.id ?? 0
            completion(true)
        }
    }
    
    // 保存家庭數據
    func save(completion: @escaping (Bool) -> Void) {
        let saveData: [String: Any] = ["id": self.id, "userId": self.userId, "name": self.name, "remark": self.remark]
        WebSocketManager.shared.sendRequest(request: "house", action: "save", data: saveData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // 刪除家庭
    func delete(completion: @escaping (Bool) -> Void) {
        let deleteData: [String: Any] = ["id": self.id]
        WebSocketManager.shared.sendRequest(request: "house", action: "delete", data: deleteData) { (response: Response?) in
            guard let response = response, response.status == "success" else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
