//
//  ChatBubble.swift
//  MadnessChatBot
//
//  Created by Ryan LIM on 2025-03-08.
//
import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.content)
                .padding()
                .background(message.isUser ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .scaleEffect(message.isUser ? 1.1 : 1.0)
                .animation(.spring(), value: message.isUser)
            
            if !message.isUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

