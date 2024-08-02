//
//  SmartHomeApp.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/1.
//

import SwiftUI

@main
struct SmartHomeApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView()
            }
            else {
                LoginView()
            }
        }
    }
}
