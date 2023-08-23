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
}
