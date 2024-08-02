import SwiftUI

struct LoginView: View {
    @StateObject private var userModel = UserModel.shared
    @State private var showError = false
    
    var body: some View {
        
        GeometryReader { geometry in
            NavigationStack {
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
                        AuthViewInput(text: $userModel.email, title: "電子郵件", placeholder: "請輸入電子郵件")
                        
                        AuthViewInput(text: $userModel.password, title: "密碼", placeholder: "請輸入密碼", isSecureField: true)
                        
                        Button {
                            handleLogin()
                        } label: {
                            Text("登入")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 10)
                        
                        if showError {
                            Text("輸入錯誤，請再重試一次！")
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    NavigationLink {
                        RegisterView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack(spacing: 3) {
                            Text("沒有帳號？")
                            Text("去註冊")
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
    }
    
    private func handleLogin() {
        userModel.login { success in
            if success {
                print("登入成功")
            } else {
                print("登入失敗")
                showError = true
            }
        }
    }
}

#Preview {
    LoginView()
}
