//
//  RoomButton.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/9.
//

import SwiftUI

struct RoomButton: View {
    @ObservedObject var room: RoomModel
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: room.icon)
                .font(.largeTitle)
                .foregroundColor(isSelected ? .blue : .gray)
            Text(room.name)
                .font(.headline)
                .foregroundColor(isSelected ? .primary : .gray)
        }
        .frame(minWidth: 55, minHeight: 65)
        .padding()
        .background(isSelected ? Color("ButtonColor") : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 3)
        )
        .shadow(color: isSelected ? .gray.opacity(0.2) : .clear, radius: isSelected ? 5 : 0)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeOut(duration: 0.3), value: isSelected)
    }
}

#Preview {
    RoomButton(room: RoomModel(id: 1, houseId: 1, name: "Room", icon: "house.fill"), isSelected: true)
}
