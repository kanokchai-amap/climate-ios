//
//  ForecastInteractor.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ForecastBusinessLogic {
    func getForecastWeather(request: Forecast.FiveDaysWeather.Request)
}

protocol ForecastDataStore {
}

class ForecastInteractor: ForecastBusinessLogic, ForecastDataStore {
    var presenter: ForecastPresentationLogic?
    var worker: WeatherWorkerLogic? = WeatherWorker()
    
    //​ MARK: Function
    func getForecastWeather(request: Forecast.FiveDaysWeather.Request) {
        typealias Resposne = Forecast.FiveDaysWeather.Response
        let lat: String = String(request.lat)
        let lon: String = String(request.lon)
        worker?.getForecastWeather(lat: lat, lon: lon, onSuccess: { data in
            let response: Resposne = Resposne(result: .success(result: data))
            self.presenter?.presenterGetForecastWeather(response: response)
        }, onError: { error in
            let response: Resposne = Resposne(result: .failure(error: error))
            self.presenter?.presenterGetForecastWeather(response: response)
        })
    }
}
