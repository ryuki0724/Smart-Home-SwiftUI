//
//  MainTabView.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/7.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        VStack {
            TabView {
                HomeView()
                    .tabItem {
                        Label("家庭", systemImage: "house")
                    }
                
                AutomateView()
                    .tabItem {
                        Label("自動化", systemImage: "deskclock")
                    }
                
                NotificationsView()
                    .tabItem {
                        Label("通知", systemImage: "bell")
                    }
                
                SettingView()
                    .tabItem {
                        Label("設定", systemImage: "gear")
                    }
            }
        }
    }
}

#Preview {
    MainTabView()
}
