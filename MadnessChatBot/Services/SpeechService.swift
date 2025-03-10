//
//  SpeechService.swift
//  MadnessChatBot
//
//  Created by Ryan LIM on 2025-03-08.
//

import AVFoundation

struct SpeechService {
    static let synthesizer = AVSpeechSynthesizer()
    
    static func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.6
        synthesizer.speak(utterance)
    }
}
