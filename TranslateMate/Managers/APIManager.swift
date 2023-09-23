//
//  APIManager.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 16/09/2023.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    func translate(sourceText: String, target: String, source: String = "en", completion: @escaping ((_ translation: String) -> Void)) {
        let headers: [String: String] = [
            "X-RapidAPI-Key": "42abd4dd86msha0250c6daf8f1b7p1b0618jsn59f4dd9f81bb",
            "X-RapidAPI-Host": "translated-mymemory---translation-memory.p.rapidapi.com"
        ]
        
        let body = NSMutableData(data: "langpair=\(source)|\(target)".data(using: .utf8)!)
        body.append("&q=\(sourceText)".data(using: .utf8)!)
        
        let endpoint = "https://translated-mymemory---translation-memory.p.rapidapi.com/get?langpair=\(source)%7C\(target)&q=\(sourceText.replacingOccurrences(of: " ", with: "%20"))&mt=1&onlyprivate=0&de=a%40b.c"
        guard let url = URL(string: endpoint) else { return }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            guard error == nil,
                  let data = data,
                  let response = try? JSONDecoder().decode(Response.self, from: data),
                  let translation = response.matches.first?.translation as? String else { return }
            
            DispatchQueue.main.async {
                completion(translation)
            }
        }.resume()
    }
}
