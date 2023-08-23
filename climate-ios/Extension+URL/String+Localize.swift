//
//  String+Localize.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//

import Foundation

extension String {
    
    func localize() -> String {
        let languageObject: [ContentUILanguage] = Language.shared.languageObject
        if let content: String = languageObject.first(where: { $0.code == self })?.content {
            return content
        } else {
            guard let pathResource: String = Bundle.main.path(forResource: "en", ofType: "lproj") else { return self }
            guard let bundle: Bundle = Bundle(path: pathResource) else { return self }
            let result: String = NSLocalizedString(self, tableName: "Screens", bundle: bundle, value: "", comment: "")
            guard result == self else { return result }
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
    }
}

import Foundation

class ContentUILanguage {
    public var code: String?
    public var content: String?
    
    init(from json: [String: Any]) {
        code = json["code"] as? String
        content = json["content"] as? String
    }
    
    init(code: String, content: String) {
        self.code = code
        self.content = content
    }
}
