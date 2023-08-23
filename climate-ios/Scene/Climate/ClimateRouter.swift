//
//  ClimateRouter.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ClimateRoutingLogic {
//    func routeToSomewhere()
}

protocol ClimateDataPassing {
    var dataStore: ClimateDataStore? { get }
}

class ClimateRouter: ClimateRoutingLogic, ClimateDataPassing {
    weak var viewController: ClimateViewController?
    var dataStore: ClimateDataStore?
  
    // MARK: Routing
  
//    func routeToSomewhere() {
//    }
}
