//
//  ChatMessage.swift
//  MadnessChatBot
//
//  Created by Ryan LIM on 2025-03-08.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}
