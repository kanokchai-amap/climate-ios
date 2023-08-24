//
//  ClimateModels.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

enum Climate {
  
    // MARK: Use cases
    enum GetWeahterByCurrentLocation {
        struct Request {
            let lat: Double
            let lon: Double
        }
        
        struct Response {
            let result: UserResult<WeatherModel>
        }
        
        struct ViewModel {
            let content: Content<WeatherModel, ErrorCase>
        }
        
        enum ErrorCase: Error {
            case alert
        }
    }
    
    enum GetWeahterByCity {
        struct Request {
            let q: String
        }
        
        struct Response {
            let result: UserResult<WeatherModel>
        }
        
        struct ViewModel {
            let content: Content<WeatherModel, ErrorCase>
        }
        
        enum ErrorCase: Error {
            case alert
        }
    }
    
    enum ChangeUnitDegree {
        struct Request {
            let isCelsius: Bool
        }
        
        struct Response {}
        struct ViewModel {}
    }
    
    enum RouteToForecast {
        struct Request {
            let lat: Double
            let lon: Double
        }
        
        struct Response {}
        struct ViewModel {}
    }
}
