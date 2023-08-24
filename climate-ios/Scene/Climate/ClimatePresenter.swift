//
//  ClimatePresenter.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ClimatePresentationLogic {
    func presenterGetCurrentWeather(response: Climate.GetWeahterByCurrentLocation.Response)
    func presenterGetWeatherByCity(response: Climate.GetWeahterByCity.Response)
    func presenterChangeUnitDegree(response: Climate.ChangeUnitDegree.Response)
    func presenterRouteToForecast(response: Climate.RouteToForecast.Response)
}

class ClimatePresenter: ClimatePresentationLogic {
    weak var viewController: ClimateDisplayLogic?
  
    // MARK: Function
    func presenterGetCurrentWeather(response: Climate.GetWeahterByCurrentLocation.Response) {
        typealias ViewModel = Climate.GetWeahterByCurrentLocation.ViewModel
        typealias ErrorCase = Climate.GetWeahterByCurrentLocation.ErrorCase
        let viewModel: ViewModel
        switch response.result {
        case .loading:
            viewModel = ViewModel(content: .loading)
        case .success(let result):
            viewModel = ViewModel(content: .success(data: result))
        case .failure(let error):
            let viewModelError: ViewModelError = ViewModelError(customError: error, case: ErrorCase.alert)
            viewModel = ViewModel(content: .error(error: viewModelError))
        }
        viewController?.displayGetCurrentWeather(viewModel: viewModel)
    }
    
    func presenterGetWeatherByCity(response: Climate.GetWeahterByCity.Response) {
        typealias ViewModel = Climate.GetWeahterByCity.ViewModel
        typealias ErrorCase = Climate.GetWeahterByCity.ErrorCase
        let viewModel: ViewModel
        switch response.result {
        case .loading:
            viewModel = ViewModel(content: .loading)
        case .success(let result):
            viewModel = ViewModel(content: .success(data: result))
        case .failure(let error):
            let viewModelError: ViewModelError = ViewModelError(customError: error, case: ErrorCase.alert)
            viewModel = ViewModel(content: .error(error: viewModelError))
        }
        viewController?.displayGetWeatherByCity(viewModel: viewModel)
    }
    
    func presenterChangeUnitDegree(response: Climate.ChangeUnitDegree.Response) {
        typealias ViewModel = Climate.ChangeUnitDegree.ViewModel
        let viewModel: ViewModel = ViewModel()
        self.viewController?.displayChangeUnitDegree(viewModel: viewModel)
    }
    
    func presenterRouteToForecast(response: Climate.RouteToForecast.Response) {
        typealias ViewModel = Climate.RouteToForecast.ViewModel
        let viewModel: ViewModel = ViewModel()
        self.viewController?.displayRouteToForecast(viewModel: viewModel)
    }
}
