//
//  ForecastViewController.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ForecastDisplayLogic: AnyObject {
    func displaySomething(viewModel: Forecast.Something.ViewModel)
}

class ForecastViewController: BaseViewController {
    
    var interactor: ForecastBusinessLogic?
    var router: (ForecastRoutingLogic & ForecastDataPassing)?
    
    // MARK: IBOutlet
    
//    @IBOutlet private var nameLabel: UILabel!

    // MARK: Object lifecycle
  
    override public func awakeFromNib() {
        super.awakeFromNib()
        configure(viewController: self)
    }

    // MARK: Setup
  
    func configure(viewController: ForecastViewController) {
        let interactor: ForecastInteractor = ForecastInteractor()
        let presenter: ForecastPresenter = ForecastPresenter()
        let router: ForecastRouter = ForecastRouter()
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
        doSomething()
    }
  
    // MARK: Function
  
    private func doSomething() {
        typealias Request = Forecast.Something.Request
        let request: Request = Request()
        interactor?.doSomething(request: request)
    }
}

extension ForecastViewController: ForecastDisplayLogic {
    
    func displaySomething(viewModel: Forecast.Something.ViewModel) {
        switch viewModel.content {
        case .loading:
            startLoading()
        case .success(let data):
            stopLoading()
        case .error(let error):
            stopLoading()
            DialogView.showDialog(error: error.customError)
        default:
            stopLoading()
        }
    }
}
