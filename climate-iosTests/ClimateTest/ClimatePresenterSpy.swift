//
//  ClimatePresenterSpy.swift
//  climate-iosTests
//
//  Created by Kanokchai Amaphut on 24/8/2566 BE.
//

import Foundation
@testable import climate_ios

class ClimatePresenterSpy: ClimatePresentationLogic {
    var stateCall: DataAssertResultState = DataAssertResultState()
    var weatherModel: WeatherModel?
    var responseError: CustomError?
    
    func presenterGetCurrentWeather(response: climate_ios.Climate.GetWeahterByCurrentLocation.Response) {
        switch response.result {
        case .loading:
            stateCall.callLoading += 1
        case .success(result: let result):
            stateCall.callSuccess += 1
            weatherModel = result
        case .failure(error: let error):
            stateCall.callError += 1
            responseError = error
        }
    }
    
    func presenterGetWeatherByCity(response: climate_ios.Climate.GetWeahterByCity.Response) {
        switch response.result {
        case .loading:
            stateCall.callLoading += 1
        case .success(result: let result):
            stateCall.callSuccess += 1
            weatherModel = result
        case .failure(error: let error):
            stateCall.callError += 1
            responseError = error
        }
    }
    
    func presenterChangeUnitDegree(response: climate_ios.Climate.ChangeUnitDegree.Response) {
    }
    
    func presenterRouteToForecast(response: climate_ios.Climate.RouteToForecast.Response) {
        
    }
    
    
}
