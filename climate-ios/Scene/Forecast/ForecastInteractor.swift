//
//  ForecastInteractor.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ForecastBusinessLogic {
    func getForecastWeather(request: Forecast.FiveDaysWeather.Request)
    func getDataStore(request: Forecast.GetDataStore.Request)
    func filterForecastWeather(request: Forecast.FilterForecastWeatherData.Request)
}

protocol ForecastDataStore {
    var lat: Double? { get set }
    var lon: Double? { get set }
}

class ForecastInteractor: ForecastBusinessLogic, ForecastDataStore {
    var presenter: ForecastPresentationLogic?
    var worker: WeatherWorkerLogic? = WeatherWorker()
    
    var lat: Double?
    var lon: Double?
    
    var listWeaherDays: [[String: Any]] = []
    var days: [String] = []
    
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
    
    func getDataStore(request: Forecast.GetDataStore.Request) {
        typealias Response = Forecast.GetDataStore.Response
        let response: Response = Response(lat: unwrapped(lat, with: 0), lon: unwrapped(lon, with: 0))
        self.presenter?.presenterGetDataStore(resposne: response)
    }
    
    func filterForecastWeather(request: Forecast.FilterForecastWeatherData.Request) {
        typealias Response = Forecast.FilterForecastWeatherData.Response
        filterForecast(forecastWeatherData: request.forecastWeatherData)
        let response: Response = Response(listWeaherDays: listWeaherDays, days: days)
        self.presenter?.presenterFilterForecastWeather(response: response)
    }
    
    private func filterForecast(forecastWeatherData: ForecastWeatherModel) {
        let list: [WeatherModel] = unwrapped(forecastWeatherData.list, with: [])
        var listDict: [[String: Any]] = []
        
        for i in list {
            let fullDataTime: String = unwrapped(i.dt_txt, with: "")
            let arr = fullDataTime.split {$0 == " "}
            let strDate: String = String(arr[0])
            
            if strDate != strDate {
                days.append(strDate)
            }
            
            if days.contains(strDate) == false {
                days.append(strDate)
            }
            
        }
        
        for dayDate in days {
            let dict: [String: Any] = [
                dayDate: list.filter { item in
                    let fullDataTime: String = unwrapped(item.dt_txt, with: "")
                    let arr = fullDataTime.split {$0 == " "}
                    let strDate: String = String(arr[0])
                    
                    return strDate == dayDate
                },
            ]
            listDict.append(dict)
        }
                
        listWeaherDays = listDict
    }
}
