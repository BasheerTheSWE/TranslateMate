//
//  APIManager.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 16/09/2023.
//

import UIKit

class APIManager {
    
    static let shared = APIManager()
    
    func translate(parent: UIViewController, sourceText: String, target: String, source: String = "en", completion: @escaping ((_ translation: String?) -> Void)) {
        // API's headers
        let headers: [String: String] = [
            // Don't event think about stealing this my friend, I'm using the free plan anyway 😛
            // You can just go to rapidapi.com, look up "MyMemory - Translation Memory" and get your own keys ...
            
            "X-RapidAPI-Key" : "42abd4dd86msha0250Bc6daf8f1b7p1b0618jsn59f4dd9f81bb",
            "X-RapidAPI-Host": "translated-mymemory---translation-memory.p.rapidapi.com"
        ]
        
        // Configuring the endpoint
        let text = sourceText.replacingOccurrences(of: " ", with: "%20")
        let endpoint = "https://translated-mymemory---translation-memory.p.rapidapi.com/get?langpair=\(source)%7C\(target)&q=\(text)&mt=1&onlyprivate=0&de=a%40b.c"
        
        // The URL & URLRequest Configurations
        guard let url = URL(string: endpoint) else { return }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        // Retrieving the data
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            guard error == nil,
                  let data = data,
                  let response = try? JSONDecoder().decode(Response.self, from: data),
                  let translation = response.matches.first?.translation as? String else {
                
                // If anything went wrong this alert will be shown to the user
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Network Error", message: "Unable to establish a network connection. Please check your internet connectivity and try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    
                    parent.present(alert, animated: true)
                    completion(nil)
                }
                
                return
            }
            
            // Success
            DispatchQueue.main.async {
                completion(translation)
            }
        }
        
        task.resume()
    }
}
