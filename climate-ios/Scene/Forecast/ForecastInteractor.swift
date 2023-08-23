//
//  ForecastInteractor.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ForecastBusinessLogic {
}

protocol ForecastDataStore {
}

class ForecastInteractor: ForecastBusinessLogic, ForecastDataStore {
    var presenter: ForecastPresentationLogic?
    lazy var worker: ForecastWorker? = ForecastWorker()
//    var name: String = ""
    
    //​ MARK: Function
}
