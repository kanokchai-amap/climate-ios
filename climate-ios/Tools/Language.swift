//
//  Language.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//

import Foundation

class Language {
    var languageObject: [ContentUILanguage] = []
    static let shared: Language = Language()
    var current: LanguageType {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "language")
        }
        
        get {
            let languageUserDefault: String? = UserDefaults.standard.string(forKey: "language")
            let defaultLanguage: String = unwrapped(languageUserDefault, with: getSystemDefaultLanguage())
            return unwrapped(LanguageType(rawValue: defaultLanguage), with: LanguageType.EN)
        }
    }
    
    func getSystemDefaultLanguage() -> String {
        let preferredLanguage: String = NSLocale.preferredLanguages[0]
        let arrLanguage: [String] = preferredLanguage.components(separatedBy: "-")
        let deviceLanguage: String = unwrapped(arrLanguage.first, with: "EN").uppercased()
        switch deviceLanguage {
        case "TH":
            return "th"
        default:
            return "en"
        }
    }
}

