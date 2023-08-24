//
//  ForecastPresenter.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ForecastPresentationLogic {
    func presenterGetForecastWeather(response: Forecast.FiveDaysWeather.Response)
    func presenterGetDataStore(resposne: Forecast.GetDataStore.Response)
    func presenterFilterForecastWeather(response: Forecast.FilterForecastWeatherData.Response)
}

class ForecastPresenter: ForecastPresentationLogic {
    weak var viewController: ForecastDisplayLogic?
  
    // MARK: Function
    func presenterGetForecastWeather(response: Forecast.FiveDaysWeather.Response) {
        typealias ViewModel = Forecast.FiveDaysWeather.ViewModel
        typealias ErrorCase = Forecast.FiveDaysWeather.ErrorCase
        let viewModel: ViewModel
        switch response.result {
        case .loading:
            viewModel = ViewModel(content: .loading)
        case .success(let result):
            viewModel = ViewModel(content: .success(data: result))
        case .failure(error: let error):
            let viewModelError: ViewModelError = ViewModelError(customError: error, case: ErrorCase.alert)
            viewModel = ViewModel(content: .error(error: viewModelError))
        }
        viewController?.displayGetForecastWeather(viewModel: viewModel)
    }
    
    func presenterGetDataStore(resposne: Forecast.GetDataStore.Response) {
        typealias ViewModel = Forecast.GetDataStore.ViewModel
        let viewModel: ViewModel = ViewModel(lat: resposne.lat, lon: resposne.lon)
        self.viewController?.displayGetDataStore(viewModel: viewModel)
    }
    
    func presenterFilterForecastWeather(response: Forecast.FilterForecastWeatherData.Response) {
        typealias ViewModel = Forecast.FilterForecastWeatherData.ViewModel
        let viewModel: ViewModel = ViewModel(listWeaherDays: response.listWeaherDays, days: response.days)
        self.viewController?.displayFilterForecaseWeather(viewModel: viewModel)
    }
}
