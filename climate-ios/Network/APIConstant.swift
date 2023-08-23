//
//  APIConstant.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import Foundation

struct APIConstant {
    
    struct Server {
        static let baseUrl: String = "https://api.openweathermap.org/data/2.5"
    }
    
    struct Parameter {
        static let lat: String = "lat"
        static let lon: String = "lon"
        static let appid: String = "appid"
        static let units: String = "units"
        static let q: String = "q"
    }
}
