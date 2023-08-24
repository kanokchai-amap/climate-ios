//
//  ClimateWorkerSpy.swift
//  climate-iosTests
//
//  Created by Kanokchai Amaphut on 24/8/2566 BE.
//

import Foundation
@testable import climate_ios

class ClimateWorkerSpy: WeatherWorkerLogic {
    var isRetureSuccess: Bool = true
    var errorData: CustomError = .defaultTest
    var weatherModel: WeatherModel = WeatherModel(from: [:])
    
    func getCurrentWeather(lat: String, lon: String, onSuccess: @escaping (climate_ios.WeatherModel) -> Void, onError: @escaping (climate_ios.CustomError) -> Void) {
        if isRetureSuccess {
            onSuccess(weatherModel)
        } else {
            onError(errorData)
        }
    }
    
    func getWeatherByCity(q: String, onSuccess: @escaping (climate_ios.WeatherModel) -> Void, onError: @escaping (climate_ios.CustomError) -> Void) {
        if isRetureSuccess {
            onSuccess(weatherModel)
        } else {
            onError(errorData)
        }
    }
    
    func getForecastWeather(lat: String, lon: String, onSuccess: @escaping (climate_ios.ForecastWeatherModel) -> Void, onError: @escaping (climate_ios.CustomError) -> Void) {
        
    }
}
