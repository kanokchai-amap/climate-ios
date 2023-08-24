//
//  ForecastModels.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

enum Forecast {
  
    // MARK: Use cases
  
    enum Something {
        struct Request {
        }
        
        struct Response {
            let result: UserResult<Data>
            
            struct Data {
            }
        }
        
        struct ViewModel {
            let content: Content<Data, ErrorCase>
            
            struct Data {
            }
        }
        
        enum ErrorCase: Error {
            case alert
        }
    }
    
    enum FiveDaysWeather {
        struct Request {
            let lat: Double
            let lon: Double
        }
        
        struct Response {
            let result: UserResult<ForecastWeatherModel>
        }
        
        struct ViewModel {
            let content: Content<ForecastWeatherModel, ErrorCase>
        }
        
        enum ErrorCase: Error {
            case alert
        }
    }
    
    enum GetDataStore {
        struct Request {}
        
        struct Response {
            let lat: Double
            let lon: Double
        }
        
        struct ViewModel {
            let lat: Double
            let lon: Double
        }
    }
    
    enum FilterForecastWeatherData {
        struct Request {
            let forecastWeatherData: ForecastWeatherModel
        }
        
        struct Response {
            let listWeaherDays: [[String: Any]]
            let days: [String]
        }
        
        struct ViewModel {
            let listWeaherDays: [[String: Any]]
            let days: [String]
        }
    }
}
