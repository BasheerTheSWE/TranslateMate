//
//  APIManager.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 16/09/2023.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    func translate(text: String, target: String, source: String, completion: @escaping ((Data) -> Void)) {        
        let headers: [String: String] = [
            "content-type": "application/x-www-form-urlencoded",
            "Accept-Encoding": "application/gzip",
            "X-RapidAPI-Key": "42abd4dd86msha0250c6daf8f1b7p1b0618jsn59f4dd9f81bb",
            "X-RapidAPI-Host": "google-translate1.p.rapidapi.com"
        ]

        // Request
        guard let url = URL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2") else { return }
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        let body = NSMutableData(data: "q=\(text)".data(using: .utf8)!)
        body.append("&target=\(target)".data(using: .utf8)!)
        body.append("&source=\(source)".data(using: .utf8)!)

        // Parameters
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = body as Data

        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            guard error == nil,
                  let data = data else { return }
            completion(data)

        }.resume()
    }
}
