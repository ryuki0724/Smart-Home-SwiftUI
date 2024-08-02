//
//  AuthViewInput.swift
//  SmartHomeApp
//
//  Created by 吉田龍生 on 2024/4/27.
//

import SwiftUI

struct AuthViewInput: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color.primary)
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
            else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
            
            Divider()
        }
    }
}

#Preview {
    AuthViewInput(text: .constant(""), title: "帳號", placeholder: "林俊偉")
}
