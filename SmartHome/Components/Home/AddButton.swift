//
//  AddButton.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/16.
//

import SwiftUI

struct AddButton: View {
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .frame(height: 40)
            
            VStack() {
                Spacer()
                
                Text("添加配件")
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .frame(height: 130)
        .background(Color(.systemGray4))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    AddButton()
}
