//
//  SettingView.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/1.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var userModel = UserModel.shared
    
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var FaceIDLock = false
    
    @AppStorage("storedUsername") var storedUsername: String = ""
    @AppStorage("storedEmail") var storedEmail: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.title)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(storedUsername)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(storedEmail)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Section("一般") {
                    HStack {
                        Text("版本")
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Section("個人偏好") {
                    Group {
                        Toggle("生物辨識", isOn: $FaceIDLock)
                        Toggle("允許通知", isOn: $notificationsEnabled)
                        Toggle("暗黑模式", isOn: $darkModeEnabled)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                Section("帳號") {
                    Button("登出") {
                        handleLogout()
                    }
                    
                    Button("刪除帳號") {
                        // Handle log out
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("設定")
        }
    }
    
    private func handleLogout() {
        userModel.logout()
        print("成功登出")
    }
}

#Preview {
    SettingView()
}
