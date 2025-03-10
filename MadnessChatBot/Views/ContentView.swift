import SwiftUI

struct ContentView: View {
    @State private var chatHistory: [ChatMessage] = []
    @State private var userInput: String = ""
    @State private var madnessLevel: Double = 0
    @State private var gameStarted = false
    @State private var startTime: Date?
    @State private var typingSpeed: Double = 0.05
    @State private var localHighScore: Double = ScoreManager.getHighScore()
    @State private var showLeaderboard = false
    
    var body: some View {
        VStack {
            // Top Header
            HStack {
                Button(action: resetGame) {
                    Image(systemName: "arrow.counterclockwise")
                        .padding()
                }
                Spacer()
                Text("Try Me")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: { showLeaderboard.toggle() }) {
                    Image(systemName: "line.horizontal.3")
                        .padding()
                }
            }
            
            // Anger Face & Progress Bar
            VStack {
                Text(getEmojiForMadness())
                    .font(.system(size: 50))
                Text("Anger")
                    .font(.caption)
                
                ProgressView(value: madnessLevel, total: 100)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(madnessLevel > 75 ? .red : .orange)
                    .padding()
            }
            Spacer()
            
            // Chat Display with Auto-Scroll
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(chatHistory) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: .infinity)
                .onChange(of: chatHistory.count) { _ in
                    withAnimation {
                        proxy.scrollTo(chatHistory.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // User Input Field
            HStack {
                TextField("Enter your message...", text: $userInput, onCommit: sendMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                }
                .padding()
            }
            
            // High Score
            if madnessLevel >= 100 {
                Text("High Score: \(String(format: "%.2f", localHighScore))s")
                    .font(.caption)
                    .padding()
            }
        }
        .padding()
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardView()
        }
    }
    
    func sendMessage() {
        guard !userInput.isEmpty else { return }

        if !gameStarted {
            gameStarted = true
            startTime = Date()
        }

        let userMsg = userInput
        DispatchQueue.main.async {
            userInput = ""  // ✅ Clears input immediately
        }

        let newUserMessage = ChatMessage(content: "🧑: \(userMsg)", isUser: true)
        chatHistory.append(newUserMessage)

        SentimentAnalyzer.analyze(text: userMsg) { sentimentScore in
            DispatchQueue.main.async {
                if sentimentScore < 0 {  //  Negative sentiment (increase madness)
                    madnessLevel += abs(sentimentScore) * 50
                } else if madnessLevel > 0 {  //  Reduce madness only if above 0
                    madnessLevel -= sentimentScore * 30
                }

                //  Ensure madness stays between 0 - 100
                madnessLevel = max(0, min(madnessLevel, 100))

                if madnessLevel >= 100 {
                    let elapsed = Date().timeIntervalSince(startTime ?? Date())
                    let finalMessage = ChatMessage(content: "🤖: YOU HAVE BROKEN ME! Time: \(String(format: "%.2f", elapsed))s", isUser: false)
                    chatHistory.append(finalMessage)

                    ScoreManager.updateHighScore(elapsed)
                } else {
                    AIService.fetchResponse(for: userMsg) { response in
                        DispatchQueue.main.async {
                            let botResponse = ChatMessage(content: "🤖: \(response)", isUser: false)
                            chatHistory.append(botResponse)
                            //SpeechService.speak(response)
                        }
                    }
                }
            }
        }
    }

    
    func resetGame() {
        madnessLevel = 0
        chatHistory = []
        gameStarted = false
        startTime = nil
    }

    func getEmojiForMadness() -> String {
        switch madnessLevel {
        case 0..<30: return "😐"
        case 30..<60: return "😠"
        case 60..<100: return "😡"
        default: return "🤬"
        }
    }
}


#Preview{
    ContentView()
}
