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
    func displayFilterForecaseWeather(viewModel: Forecast.FilterForecastWeatherData.ViewModel)
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
    var listWeaherDays: [[String: Any]] = []
    var days: [String] = []
    
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
        self.navigationItem.title = "forecast_001".localize()
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: ForecastItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ForecastItemTableViewCell.identifier)
        tableView.register(UINib(nibName: HeaderSectionView.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderSectionView.identifier)
        tableView.reloadData()
    }
}

// MARK: - ForecastViewController - UITableViewDelegate, UITableViewDataSource
extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listWeaherDays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int = unwrapped(listWeaherDays[section].first?.value as? [WeatherModel], with: []).count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ForecastItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: ForecastItemTableViewCell.identifier, for: indexPath) as? ForecastItemTableViewCell else {
            return UITableViewCell()
        }
        cell.indexPath = indexPath
        let listWeather: [WeatherModel] = unwrapped(listWeaherDays[indexPath.section].first?.value as? [WeatherModel], with: [])
        cell.weatherData = listWeather[indexPath.row]
        cell.forecastWeatherData = forecastWeatherData
        cell.setupData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderSectionView.identifier) as? HeaderSectionView else {
            return UIView()
        }
        
        let dateTime: String = days[section]
        let fullTime: DateFormatter = DateFormatter()
        fullTime.dateFormat = "yyyy-MM-dd"
        let date: Date = unwrapped(fullTime.date(from: dateTime), with: Date())
        
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.locale = Language.shared.current.getLocale()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let timeStr: String = dateFormat.string(from: date)
        
        headerView.headerLabel.text = timeStr
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
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
    
    func filterForecastWeather() {
        typealias Request = Forecast.FilterForecastWeatherData.Request
        let request: Request = Request(forecastWeatherData: forecastWeatherData)
        interactor?.filterForecastWeather(request: request)
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
            filterForecastWeather()
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
    
    func displayFilterForecaseWeather(viewModel: Forecast.FilterForecastWeatherData.ViewModel) {
        listWeaherDays = viewModel.listWeaherDays
        days = viewModel.days
        tableView.reloadData()
    }
}
