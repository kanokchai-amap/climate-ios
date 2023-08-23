//
//  Enum.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//

import Foundation

enum LanguageType: String {
    case TH = "th"
    case EN = "en"
    
    func getLocale() -> Locale {
        switch self {
        case .TH:
            return Locale(identifier: "th_TH")
        default:
            return Locale(identifier: "en_US")
        }
    }
    
    func getStringLocalize() -> String {
        switch self {
        case .TH:
            return "th"
        default:
            return "en"
        }
    }
    
    func getStringLanguageSetting() -> String {
        switch self {
        case .TH:
            return "ภาษาไทย"
        default:
            return "English"
        }
    }
}

