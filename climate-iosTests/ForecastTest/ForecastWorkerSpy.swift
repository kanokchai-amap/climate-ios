//
//  ForecastWorkerSpy.swift
//  climate-iosTests
//
//  Created by Kanokchai Amaphut on 24/8/2566 BE.
//

import Foundation
@testable import climate_ios

class ForecastWorkerSpy: WeatherWorkerLogic {
    var isRetureSuccess: Bool = true
    var errorData: CustomError = .defaultTest
    var forecastWeatherModel: ForecastWeatherModel = ForecastWeatherModel(from: [:])
    
    func getCurrentWeather(lat: String, lon: String, onSuccess: @escaping (climate_ios.WeatherModel) -> Void, onError: @escaping (climate_ios.CustomError) -> Void) {
    }
    
    func getWeatherByCity(q: String, onSuccess: @escaping (climate_ios.WeatherModel) -> Void, onError: @escaping (climate_ios.CustomError) -> Void) {
    }
    
    func getForecastWeather(lat: String, lon: String, onSuccess: @escaping (climate_ios.ForecastWeatherModel) -> Void, onError: @escaping (climate_ios.CustomError) -> Void) {
        if isRetureSuccess {
            onSuccess(forecastWeatherModel)
        } else {
            onError(errorData)
        }
    }
}
