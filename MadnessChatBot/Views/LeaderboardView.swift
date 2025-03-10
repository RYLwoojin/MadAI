import SwiftUI

struct LeaderboardView: View {
    @State private var highScore: Double = ScoreManager.getHighScore()

    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("🔥 Best Time: \(String(format: "%.2f", highScore))s")
                .font(.title2)
                .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
