import NaturalLanguage

struct SentimentAnalyzer {
    static func analyze(text: String, completion: @escaping (Double) -> Void) {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let sentiment = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        let sentimentScore = Double(sentiment?.rawValue ?? "0") ?? 0

        print("🔍 Sentiment Analysis - Input: \(text) → Score: \(sentimentScore)") // ✅ Debug log

        completion(sentimentScore)
    }
}
