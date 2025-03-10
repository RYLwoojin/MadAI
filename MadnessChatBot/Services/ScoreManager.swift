import Foundation

struct ScoreManager {
    static func getHighScore() -> Double {
        return UserDefaults.standard.double(forKey: "highScore")
    }

    static func updateHighScore(_ elapsedTime: Double) {
        let currentHighScore = getHighScore()
        if elapsedTime < currentHighScore || currentHighScore == 0 {
            UserDefaults.standard.set(elapsedTime, forKey: "highScore")
        }
    }
}
