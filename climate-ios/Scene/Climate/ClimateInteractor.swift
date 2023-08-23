//
//  ClimateInteractor.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ClimateBusinessLogic {
}

protocol ClimateDataStore {
//    var name: String { get set }
}

class ClimateInteractor: ClimateBusinessLogic, ClimateDataStore {
    var presenter: ClimatePresentationLogic?
    lazy var worker: ClimateWorker? = ClimateWorker()
//    var name: String = ""
    
    //​ MARK: Function
}
