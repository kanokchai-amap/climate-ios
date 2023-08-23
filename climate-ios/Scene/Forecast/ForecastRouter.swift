//
//  ForecastRouter.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ForecastRoutingLogic {
//    func routeToSomewhere()
}

protocol ForecastDataPassing {
    var dataStore: ForecastDataStore? { get }
}

class ForecastRouter: ForecastRoutingLogic, ForecastDataPassing {
    weak var viewController: ForecastViewController?
    var dataStore: ForecastDataStore?
  
    // MARK: Routing
  
//    func routeToSomewhere() {
//    }
}
