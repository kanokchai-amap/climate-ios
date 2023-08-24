//
//  WeatherWorker.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import Foundation
import Alamofire

protocol WeatherWorkerLogic {
    func getCurrentWeather(lat: String, lon: String, onSuccess: @escaping(WeatherModel) -> Void, onError: @escaping(CustomError) -> Void)
    func getWeatherByCity(q: String, onSuccess: @escaping(WeatherModel) -> Void, onError: @escaping(CustomError) -> Void)
    func getForecastWeather(lat: String, lon: String, onSuccess: @escaping(ForecastWeatherModel) -> Void, onError: @escaping(CustomError) -> Void)
}

class WeatherWorker: WeatherWorkerLogic {
    
    func getUnits() -> String {
        let isClesius: Bool = unwrapped(UserDefaultService.getIsCelsius(), with: true)
        if isClesius {
            return "metric"
        } else {
            return "imperial"
        }
    }
    
    func getCurrentWeather(lat: String, lon: String, onSuccess: @escaping (WeatherModel) -> Void, onError: @escaping (CustomError) -> Void) {
        let units: String = self.getUnits()
        APIClient.shared.request(api: .getCurrentWeather(lat: lat, lon: lon, appId: AppConfig.apiKey, units: units)) { json in
            if let jsonData: [String: Any] = json.rawValue as? [String: Any] {
                onSuccess(WeatherModel(from: jsonData))
            } else {
                onError(CustomError.invalidJSON)
            }
        } onError: { error in
            onError(error)
        }
    }
    
    func getForecastWeather(lat: String, lon: String, onSuccess: @escaping (ForecastWeatherModel) -> Void, onError: @escaping (CustomError) -> Void) {
        let units: String = self.getUnits()
        APIClient.shared.request(api: .getForecastWeather(lat: lat, lon: lon, appId: AppConfig.apiKey, units: units)) { json in
            if let jsonData: [String: Any] = json.rawValue as? [String: Any] {
                onSuccess(ForecastWeatherModel(from: jsonData))
            } else {
                onError(CustomError.invalidJSON)
            }
        } onError: { error in
            onError(error)
        }
    }
    
    func getWeatherByCity(q: String, onSuccess: @escaping (WeatherModel) -> Void, onError: @escaping (CustomError) -> Void) {
        let units: String = self.getUnits()
        APIClient.shared.request(api: .getWeatherByCity(q: q, appId: AppConfig.apiKey, units: units)) { json in
            if let jsonData: [String: Any] = json.rawValue as? [String: Any] {
                onSuccess(WeatherModel(from: jsonData))
            } else {
                onError(CustomError.invalidJSON)
            }
        } onError: { error in
            onError(error)
        }
    }
}
