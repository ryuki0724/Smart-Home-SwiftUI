//
//  UserModel.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/1.
//

import Foundation
import Combine
import SwiftUI

class UserModel: Identifiable, ObservableObject {
    @Published var id: Int
    @Published var username: String
    @Published var email: String
    @Published var password: String
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    static let shared = UserModel()
    
    private init(id: Int = 0, username: String = "", email: String = "", password: String = "") {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
    }
    
    struct Response: Decodable {
        let status: String
        let message: String
        let user: User?
        
        struct User: Decodable {
            let id: Int
            let username: String
            let email: String
        }
    }
    
    func save(completion: @escaping (Bool) -> Void) {
        let saveData: [String: Any] = ["id": self.id, "username": self.username, "email": self.email, "password": self.password]
        WebSocketManager.shared.sendRequest(request: "user", action: "save", data: saveData) { (response: Response?) in
            guard let response = response else {
                completion(false)
                return
            }
            if response.status == "success", let user = response.user {
                self.updateUserData(user: user)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func delete() {
        let deleteData: [String: Any] = ["id": self.id]
        WebSocketManager.shared.sendRequest(request: "user", action: "delete", data: deleteData) { (response: Response?) in
            guard let response = response else {
                return
            }
            if response.status == "success", let user = response.user {
                self.updateUserData(user: user)
                self.isLoggedIn = false
            }
        }
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        let loginData = ["email": self.email, "password": self.password]
        WebSocketManager.shared.sendRequest(request: "user", action: "login", data: loginData) { (response: Response?) in
            guard let response = response else {
                completion(false)
                return
            }
            if response.status == "success", let user = response.user {
                self.updateUserData(user: user)
                SessionManager.shared.loginUser()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func register(completion: @escaping (Bool) -> Void) {
        let registerData = ["username": self.username, "email": self.email, "password": self.password]
        WebSocketManager.shared.sendRequest(request: "user", action: "register", data: registerData) { (response: Response?) in
            guard let response = response else {
                completion(false)
                return
            }
            if response.status == "success", let user = response.user {
                self.updateUserData(user: user)
                SessionManager.shared.loginUser()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func logout() {
        self.isLoggedIn = false
        SessionManager.shared.logoutUser()
//        let logoutData: [String: Any] = ["id": self.id]
//        WebSocketManager.shared.sendRequest(request: "user", action: "logout", data: logoutData) { (response: Response?) in
//            guard let response = response else {
//                return
//            }
//            if response.status == "success", let user = response.user {
//                self.updateUserData(user: user)
//                self.isLoggedIn = false
//            }
//        }
    }
    
    private func updateUserData(user: Response.User) {
        self.id = user.id
        self.username = user.username
        self.email = user.email
    }
}

//    func login() -> Bool {
//        if KeychainManager.shared.check(username: username, email: email, password: password) {
//            SessionManager.shared.loginUser(username: username, email: email)
//            return true
//        }
//        return false
//    }
//
//    func logout() {
//        SessionManager.shared.logoutUser()
//    }
//
//    func register() -> Bool {
//        return KeychainManager.shared.save(username: username, email: email, password: password)
//    }
//
//    func deleteAccount() -> Bool {
//        if KeychainManager.shared.delete(email: email) {
//            SessionManager.shared.logoutUser()
//            return true
//        }
//        return false
//    }
