//
//  Response.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 22/09/2023.
//

import Foundation

// This Model represents the API's response

struct Response: Codable {
    let matches: [TranslationObject]
}


struct TranslationObject: Codable {
    let segment: String
    let source: String
    let translation: String
}
