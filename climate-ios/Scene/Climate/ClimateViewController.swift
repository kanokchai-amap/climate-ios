//
//  ClimateViewController.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ClimateDisplayLogic: AnyObject {
}

class ClimateViewController: UIViewController, ClimateDisplayLogic {
    
    var interactor: ClimateBusinessLogic?
    var router: (ClimateRoutingLogic & ClimateDataPassing)?
    
    // MARK: IBOutlet
    
//    @IBOutlet private var nameLabel: UILabel!

    // MARK: Object lifecycle
  
    override public func awakeFromNib() {
        super.awakeFromNib()
        configure(viewController: self)
    }

    // MARK: Setup
  
    func configure(viewController: ClimateViewController) {
        let interactor: ClimateInteractor = ClimateInteractor()
        let presenter: ClimatePresenter = ClimatePresenter()
        let router: ClimateRouter = ClimateRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    // MARK: Function
}
