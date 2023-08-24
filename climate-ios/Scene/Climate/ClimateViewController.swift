//
//  ClimateViewController.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ClimateDisplayLogic: AnyObject {
    func displayGetCurrentWeather(viewModel: Climate.GetWeahterByCurrentLocation.ViewModel)
    func displayGetWeatherByCity(viewModel: Climate.GetWeahterByCity.ViewModel)
    func displayChangeUnitDegree(viewModel: Climate.ChangeUnitDegree.ViewModel)
    func displayRouteToForecast(viewModel: Climate.RouteToForecast.ViewModel)
}

class ClimateViewController: BaseViewController, ClimateDisplayLogic {
    
    var interactor: ClimateBusinessLogic?
    var router: (ClimateRoutingLogic & ClimateDataPassing)?
    
    // MARK: IBOutlet
    @IBOutlet private var mainLayoutView: UIView!
    @IBOutlet private var backgroundImage: UIImageView!
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var currentLocationButton: UIButton!
    @IBOutlet private var searchTextField: UITextField!
    @IBOutlet private var forecastButton: UIButton!
    @IBOutlet private var weatherImage: UIImageView!
    @IBOutlet private var contentStackView: UIStackView!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var degreeLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var minMaxDegreeLabel: UILabel!
    @IBOutlet private var chagneDegreeButton: UIButton!
    
    var isCelsius: Bool = unwrapped(UserDefaultService.getIsCelsius(), with: true)
    var weatherData: WeatherModel = WeatherModel(from: [:])
    
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
        setupView()
        getCurrentWeather()
    }
  
    // MARK: Function
    private func setupView() {
        chagneDegreeButton.layer.cornerRadius = 10
        searchTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedBackgroud))
        mainLayoutView.addGestureRecognizer(tap)
    }
    
    private func setupData() {
        let temp: Int = Int(unwrapped(weatherData.main?.temp, with: 0))
        let temp_max: Int = Int(unwrapped(weatherData.main?.temp_max, with: 0))
        let temp_min: Int = Int(unwrapped(weatherData.main?.temp_min, with: 0))
        let humidity: Int = Int(unwrapped(weatherData.main?.humidity, with: 0))
        
        weatherImage.image = UIImage(systemName: unwrapped(weatherData.weather?.first?.conditionName, with: ""))
        cityLabel.text = unwrapped(weatherData.name, with: "")

        if isCelsius {
            degreeLabel.text = "\(temp)°C"
            minMaxDegreeLabel.text = "H: \(temp_max)°C, L:\(temp_min)°C"
        } else {
            degreeLabel.text = "\(temp)°F"
            minMaxDegreeLabel.text = "H: \(temp_max)°F, L:\(temp_min)°F"
        }
        
        humidityLabel.text = "Humidity: \(humidity)"
    }
    
    @IBAction private func tappedCurrentLocation(_ sender: UIButton) {
        getCurrentWeather()
    }
    
    @IBAction private func tappedForecast(_ sender: UIButton) {
        routeToForecast()
    }
    
    @IBAction private func tappedChangDegree(_ sender: UIButton) {
        isCelsius = !isCelsius
        changeUnitDegree()
    }
    
    @objc private func tappedBackgroud() {
        self.dismissKeyboard()
    }
}

// MARK: - ClimateViewController: - UITextFieldDelegate
extension ClimateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        getWeatherByCity()
    }
}

// MARK: - ClimateViewController: Request
extension ClimateViewController {
    func getCurrentWeather() {
        typealias Request = Climate.GetWeahterByCurrentLocation.Request
        let request: Request = Request(lat: 44.34, lon: 10.99)
        interactor?.getCurrentWeather(request: request)
    }
    
    func getWeatherByCity() {
        typealias Request = Climate.GetWeahterByCity.Request
        let city: String = unwrapped(searchTextField.text, with: "")
        let request: Request = Request(q: city)
        interactor?.getWeatherByCity(request: request)
    }
    
    func changeUnitDegree() {
        typealias Request = Climate.ChangeUnitDegree.Request
        let request: Request = Request(isCelsius: isCelsius)
        interactor?.changeUnitsDegree(request: request)
    }
    
    func routeToForecast() {
        typealias Request = Climate.RouteToForecast.Request
        let request: Request = Request(lat: 44.34, lon: 10.99)
        interactor?.routeToForecast(request: request)
        
    }
}

// MARK: - ClimateViewController: Display
extension ClimateViewController {
    func displayGetCurrentWeather(viewModel: Climate.GetWeahterByCurrentLocation.ViewModel) {
        switch viewModel.content {
        case .loading:
            self.startLoading()
        case .success(let data):
            self.stopLoading()
            weatherData = data
            setupData()
        case .error(let error):
            self.stopLoading()
            DialogView.showDialog(error: error.customError)
        default:
            break
        }
    }
    
    func displayGetWeatherByCity(viewModel: Climate.GetWeahterByCity.ViewModel) {
        switch viewModel.content {
        case .loading:
            self.startLoading()
        case .success(let data):
            self.stopLoading()
            weatherData = data
            setupData()
        case .error(let error):
            self.stopLoading()
            DialogView.showDialog(error: error.customError)
        default:
            break
        }
    }
    
    func displayChangeUnitDegree(viewModel: Climate.ChangeUnitDegree.ViewModel) {
        if let isEmptyTextFiled: Bool = searchTextField.text?.isEmpty {
            if isEmptyTextFiled {
                getCurrentWeather()
            } else {
                getWeatherByCity()
            }
        }
    }
    
    func displayRouteToForecast(viewModel: Climate.RouteToForecast.ViewModel) {
        self.router?.routeToForecast()
    }
}
