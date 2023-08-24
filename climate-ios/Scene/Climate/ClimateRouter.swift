//
//  ClimateRouter.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ClimateRoutingLogic {
    func routeToForecast()
}

protocol ClimateDataPassing {
    var dataStore: ClimateDataStore? { get }
}

class ClimateRouter: BaseRouter, ClimateRoutingLogic, ClimateDataPassing {    
    var dataStore: ClimateDataStore?
  
    // MARK: Routing
    func routeToForecast() {
        let vc: ForecastViewController = StoryboardScene.Forecast.forecastViewController.instantiate()
        var destinationStore: ForecastDataStore? = vc.router?.dataStore
        destinationStore?.lat = dataStore?.lat
        destinationStore?.lon = dataStore?.lon
        pushViewController(vc)
    }
}
