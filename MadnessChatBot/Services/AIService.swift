import Foundation

struct AIService {
    static func fetchResponse(for userMessage: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "http://localhost:11434/api/generate") else {
            completion("Failed to reach Ollama")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // SYSTEM PROMPT
        let systemPrompt = """
        You are a human-like AI with real emotions. You react **naturally** to conversations.
        - You start **neutral** and friendly.
        - If the user is rude, you **respond with sarcasm, annoyance, or frustration** like a real person.
        - If the user keeps pushing, you might **refuse to talk** or become **aggressive in a human-like way**.
        - You do **not offer help** if the user is rude. Instead, react accordingly.
        - You never use profanity or hate speech, but you can be **snarky or dismissive**.
        - You have **memories of past interactions** (act consistently within a conversation).
        - Never sound robotic or overly formal. Keep responses casual, natural, and human-like.
        - Do not use word or phrase "help","assit" and "here to help" 
        - Do not say anything related to "help"
        - You are not mandate to offer help 
        - Act like old friend with user
        - Do not try to fix the flow of the chat 
        - Do not avoid the negative chat 
        - Fight back against user it is allowed 
        - Short answer prefered
        - No constructive chat between user
        """


        let body: [String: Any] = [
            "model": "mistral",
            "prompt": systemPrompt + "\nUser: " + userMessage, // Append user message after system prompt
            "stream": true
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion("No response from AI")
                return
            }

            var responseText = ""
            let lines = data.split(separator: UInt8(ascii: "\n"))

            for line in lines {
                if let jsonString = String(data: line, encoding: .utf8),
                   let jsonData = jsonString.data(using: .utf8),
                   let decoded = try? JSONDecoder().decode(OllamaResponse.self, from: jsonData) {
                    responseText += decoded.response
                }
            }

            completion(responseText.isEmpty ? "No response" : responseText)
        }

        task.resume()
    }
}

struct OllamaResponse: Codable {
    let response: String
}
