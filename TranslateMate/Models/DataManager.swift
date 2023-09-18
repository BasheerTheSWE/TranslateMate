//
//  DataManager.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 18/09/2023.
//

import Foundation

struct Language {
    let language: String
    let code: String
}

final class DataManager {
    static let shared = DataManager()
    
    func getLanguages() -> [Language] {
        let languages = [
            Language(language: "Arabic", code: "ar"),
            Language(language: "Armenian", code: "hy"),
            Language(language: "Bengali", code: "bn"),
            Language(language: "Chinese", code: "zh"),
            Language(language: "Croatian", code: "hr"),
            Language(language: "Czech", code: "cs"),
            Language(language: "English", code: "en"),
            Language(language: "Estonian", code: "et"),
            Language(language: "French", code: "fr"),
            Language(language: "German", code: "de"),
            Language(language: "Hausa", code: "ha"),
            Language(language: "Hebrew", code: "he"),
            Language(language: "Hindi", code: "hi"),
            Language(language: "Hungarian", code: "hu"),
            Language(language: "Icelandic", code: "is"),
            Language(language: "Indonesian", code: "id"),
            Language(language: "Irish", code: "ga"),
            Language(language: "Italian", code: "it"),
            Language(language: "Japanese", code: "ja"),
            Language(language: "Kongo", code: "kg"),
            Language(language: "Korean", code: "ko"),
            Language(language: "Latin", code: "la"),
            Language(language: "Mongolian", code: "mn"),
            Language(language: "Nepali", code: "ne"),
            Language(language: "Norwegian", code: "no"),
            Language(language: "Persian", code: "fa"),
            Language(language: "Polish", code: "pl"),
            Language(language: "Portuguese", code: "pt"),
            Language(language: "Punjabi", code: "pa"),
            Language(language: "Russian", code: "ru"),
            Language(language: "Sardinian", code: "sc"),
            Language(language: "Serbian", code: "sr"),
            Language(language: "Spanish", code: "es"),
            Language(language: "Swahili", code: "sw"),
            Language(language: "Swedish", code: "sv"),
            Language(language: "Thai", code: "th"),
            Language(language: "Turkish", code: "tr"),
            Language(language: "Ukrainian", code: "uk"),
            Language(language: "Urdu", code: "ur"),
            Language(language: "Vietnamese", code: "vi"),
            Language(language: "Welsh", code: "cy"),
            Language(language: "Sundanese", code: "su")
        ]
        
        return languages
    }
}
