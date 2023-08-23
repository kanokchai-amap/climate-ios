//
//  ForecastInteractor.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ForecastBusinessLogic {
    func doSomething(request: Forecast.Something.Request)
}

protocol ForecastDataStore {
//    var name: String { get set }
}

class ForecastInteractor: ForecastBusinessLogic, ForecastDataStore {
    var presenter: ForecastPresentationLogic?
    lazy var worker: ForecastWorker? = ForecastWorker()
//    var name: String = ""
    
    //​ MARK: Function
  
    func doSomething(request: Forecast.Something.Request) {
        typealias Response = Forecast.Something.Response
        presenter?.presentSomething(response: Response(result: .loading))
        worker?.doSomeWork { [weak self] (result) in
            let data: Response.Data = Response.Data()
            let response: Response = Response(result: .success(result: data))
            self?.presenter?.presentSomething(response: response)
        } onError: { [weak self] (error) in
            let response: Response = Response(result: .failure(error: error))
            self?.presenter?.presentSomething(response: response)
        }
    }
}
