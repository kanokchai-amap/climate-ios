//
//  ForecastPresenter.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ForecastPresentationLogic {
    func presentSomething(response: Forecast.Something.Response)
}

class ForecastPresenter: ForecastPresentationLogic {
    weak var viewController: ForecastDisplayLogic?
  
    // MARK: Function
  
    func presentSomething(response: Forecast.Something.Response) {
        typealias ViewModel = Forecast.Something.ViewModel
        typealias ErrorCase = Forecast.Something.ErrorCase
        let viewModel: ViewModel
        switch response.result {
        case .loading:
            viewModel = ViewModel(content: .loading)
        case .success(let data):
            let viewModelData: ViewModel.Data = ViewModel.Data()
            viewModel = ViewModel(content: .success(data: viewModelData))
        case .failure(let error):
            let viewModelError: ViewModelError = ViewModelError(customError: error, case: ErrorCase.alert)
            viewModel = ViewModel(content: .error(error: viewModelError))
        }
        viewController?.displaySomething(viewModel: viewModel)
    }
}
