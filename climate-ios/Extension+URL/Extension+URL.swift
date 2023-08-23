//
//  Extension+URL.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import Alamofire

extension URL {
    
    func append(parameters: Parameters) -> URL? {
        var components: URLComponents? = URLComponents(string: self.absoluteString)
        components?.queryItems = parameters.map { element in URLQueryItem(name: element.key, value: element.value as? String) }
        return components?.url
    }
}
