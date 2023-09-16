//
//  APIManager.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 16/09/2023.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    func translate(text: String, target: String, source: String, completion: @escaping ((Data, HTTPURLResponse) -> Void)) {
        let headers: [String: String] = [
            "content-type": "application/x-www-form-urlencoded",
            "Accept-Encoding": "application/gzip",
            "X-RapidAPI-Key": "42abd4dd86msha0250c6daf8f1b7p1b0618jsn59f4dd9f81bb",
            "X-RapidAPI-Host": "google-translate1.p.rapidapi.com"
        ]
        
        // Request
        guard let url = URL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2") else { return }
        var request = URLRequest(url: url)
        
        // Body
        let JSONObject = [
            "q": text,
            "target": target,
//            "source": source
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: JSONObject) else { return }
        
        // Parameters
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil,
                  let data = data,
                  let response = response as? HTTPURLResponse else { return }
            
            completion(data, response)
            
        }
    }
}
