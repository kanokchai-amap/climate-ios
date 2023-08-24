//
//  ForecastPresenterSpy.swift
//  climate-iosTests
//
//  Created by Kanokchai Amaphut on 24/8/2566 BE.
//

import Foundation
@testable import climate_ios

class ForecastPresenterSpy: ForecastPresentationLogic {
    var stateCall: DataAssertResultState = DataAssertResultState()
    var forecastWeatherModel: ForecastWeatherModel?
    var responseError: CustomError?
    var lat: Double = 0
    var lon: Double = 0
    
    func presenterGetForecastWeather(response: climate_ios.Forecast.FiveDaysWeather.Response) {
        switch response.result {
        case .loading:
            stateCall.callLoading += 1
        case .success(result: let result):
            stateCall.callSuccess += 1
            forecastWeatherModel = result
        case .failure(error: let error):
            stateCall.callError += 1
            responseError = error
        }
    }
    
    func presenterGetDataStore(resposne: climate_ios.Forecast.GetDataStore.Response) {
        lat = resposne.lat
        lon = resposne.lon
    }
}
