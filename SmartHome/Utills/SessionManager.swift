//
//  SessionManager.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/1.
//  用來設定全局常量
//

import Foundation
import SwiftUI

class SessionManager {
    static let shared = SessionManager()
    let userModel     = UserModel.shared

    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("storedUserId") var storedUserId: Int = 0
    @AppStorage("storedUsername") var storedUsername: String = ""
    @AppStorage("storedEmail") var storedEmail: String = ""

    func loginUser() {
        self.isLoggedIn = true
        self.storedUserId = userModel.id
        self.storedUsername = userModel.username
        self.storedEmail = userModel.email
    }

    func logoutUser() {
        self.isLoggedIn = false
        self.storedUserId = 0
        self.storedUsername = ""
        self.storedEmail = ""
    }
}
