//
//  RegisterView.swift
//  smartHome
//
//  Created by 吉田龍生 on 2024/4/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var userModel = UserModel.shared
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                VStack {
                    Text("智能生活")
                        .fontWeight(.bold)
                        .font(.system(size: 50))
                        .foregroundColor(Color.blue)
                    
                    Text("掌控未來，智慧生活一指間")
                    
                    Image("loginLogo")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, geometry.size.width * 0.1)
                        .padding(.top, 20)
                }
                
                VStack(spacing: 24) {
                    AuthViewInput(text: $userModel.username, title: "帳號", placeholder: "請輸入帳號")
                    
                    AuthViewInput(text: $userModel.email, title: "電子郵件", placeholder: "請輸入電子郵件")
                    
                    AuthViewInput(text: $userModel.password, title: "密碼", placeholder: "請輸入密碼", isSecureField: true)
                    
                    AuthViewInput(text: $confirmPassword, title: "確認密碼", placeholder: "請輸入密碼", isSecureField: true)
                    
                    Button {
                        handleRegister()
                    } label: {
                        Text("註冊")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("已有帳號？")
                        Text("去登入")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color.blue)
                }
            }
            .padding(.top, 30)
            .padding(.horizontal, geometry.size.width * 0.05)
        }
    }
    
    private func handleRegister() {
        errorMessage = ""
        
        guard !userModel.username.isEmpty, !userModel.email.isEmpty, !userModel.password.isEmpty else {
            errorMessage = "請填寫完整的帳號和密碼資訊。"
            return
        }
        
        guard isValidEmail(userModel.email) else {
            errorMessage = "請輸入有效的電子郵件地址。"
            return
        }
        
        guard userModel.password == confirmPassword else {
            errorMessage = "密碼不匹配，請再重試一次！"
            return
        }

        userModel.register { success in
            if success {
                print("註冊成功")
                dismiss()
            } else {
                print("註冊失敗")
                errorMessage = "此帳號已被註冊，請使用其他帳號。"
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        return emailPred.evaluate(with: email)
    }
}

#Preview {
    RegisterView()
}
