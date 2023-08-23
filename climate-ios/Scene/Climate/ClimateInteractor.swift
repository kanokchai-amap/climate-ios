//
//  ClimateInteractor.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ClimateBusinessLogic {
    func getCurrentWeather(request: Climate.GetWeahterByCurrentLocation.Request)
    func getWeatherByCity(request: Climate.GetWeahterByCity.Request)
}

protocol ClimateDataStore {
}

class ClimateInteractor: ClimateBusinessLogic, ClimateDataStore {
    var presenter: ClimatePresentationLogic?
    var worker: WeatherWorkerLogic? = WeatherWorker()
    
    //​ MARK: Function
    func getCurrentWeather(request: Climate.GetWeahterByCurrentLocation.Request) {
        typealias Response = Climate.GetWeahterByCurrentLocation.Response
        let lat: String = String(request.lat)
        let lon: String = String(request.lon)
        worker?.getCurrentWeather(lat: lat, lon: lon, onSuccess: { data in
            let response: Response = Response(result: .success(result: data))
            self.presenter?.presenterGetCurrentWeather(response: response)
        }, onError: { error in
            let response: Response = Response(result: .failure(error: error))
            self.presenter?.presenterGetCurrentWeather(response: response)
        })
    }
    
    func getWeatherByCity(request: Climate.GetWeahterByCity.Request) {
        typealias Response = Climate.GetWeahterByCity.Response
        worker?.getWeatherByCity(q: request.q, onSuccess: { data in
            let response: Response = Response(result: .success(result: data))
            self.presenter?.presenterGetWeatherByCity(response: response)
        }, onError: { error in
            let response: Response = Response(result: .failure(error: error))
            self.presenter?.presenterGetWeatherByCity(response: response)
        })
    }
}
