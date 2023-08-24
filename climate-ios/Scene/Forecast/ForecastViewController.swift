//
//  ForecastViewController.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ForecastDisplayLogic: AnyObject {
    func displayGetForecastWeather(viewModel: Forecast.FiveDaysWeather.ViewModel)
    func displayGetDataStore(viewModel: Forecast.GetDataStore.ViewModel)
}

class ForecastViewController: BaseViewController, ForecastDisplayLogic {
    
    var interactor: ForecastBusinessLogic?
    var router: (ForecastRoutingLogic & ForecastDataPassing)?
    
    // MARK: IBOutlet
    
    @IBOutlet private var mainLayoutView: UIView!
    @IBOutlet private var tableView: UITableView!
    
    var forecastWeatherData: ForecastWeatherModel = ForecastWeatherModel(from: [:])
    var lat: Double = 0
    var lon: Double = 0
    
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
        setupView()
        getDataStore()
    }
    
    // MARK: Function
    func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: ForecastItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ForecastItemTableViewCell.identifier)
        tableView.reloadData()
    }
}

// MARK: - ForecastViewController - UITableViewDelegate, UITableViewDataSource
extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unwrapped(forecastWeatherData.list?.count, with: 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ForecastItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: ForecastItemTableViewCell.identifier, for: indexPath) as? ForecastItemTableViewCell else {
            return UITableViewCell()
        }
        cell.indexPath = indexPath
        cell.forecastWeatherData = forecastWeatherData
        cell.setupData()
        return cell
    }
}

// MARK: - ForecastViewController: Request
extension ForecastViewController {
    func getForecastWeather() {
        typealias Request = Forecast.FiveDaysWeather.Request
        let request: Request = Request(lat: lat, lon: lon)
        interactor?.getForecastWeather(request: request)
    }
    
    func getDataStore() {
        typealias Request = Forecast.GetDataStore.Request
        let request: Request = Request()
        interactor?.getDataStore(request: request)
    }
}

// MARK: - ForecastViewController: Display
extension ForecastViewController {
    func displayGetForecastWeather(viewModel: Forecast.FiveDaysWeather.ViewModel) {
        switch viewModel.content {
        case .loading:
            startLoading()
        case .success(let data):
            stopLoading()
            forecastWeatherData = data
            tableView.reloadData()
        case .error(let error):
            stopLoading()
            DialogView.showDialog(error: error.customError)
        default:
            break
        }
    }
    
    func displayGetDataStore(viewModel: Forecast.GetDataStore.ViewModel) {
        lat = viewModel.lat
        lon = viewModel.lon
        getForecastWeather()
    }
}
