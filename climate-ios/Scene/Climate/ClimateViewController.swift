//
//  ClimateViewController.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import CoreLocation

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
    let locationManager = CLLocationManager()
    var lat: Double = 0
    var lon: Double = 0
    
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
        setupLocation()
    }
  
    // MARK: Function
    private func setupView() {
        chagneDegreeButton.layer.cornerRadius = 10
        searchTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedBackgroud))
        mainLayoutView.addGestureRecognizer(tap)
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    
        getCurrentWeather()
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
            chagneDegreeButton.setTitle("climate_001".localize(), for: .normal)

        } else {
            degreeLabel.text = "\(temp)°F"
            minMaxDegreeLabel.text = "H: \(temp_max)°F, L:\(temp_min)°F"
            chagneDegreeButton.setTitle("climate_002".localize(), for: .normal)
        }
        
        humidityLabel.text = "Humidity: \(humidity)"
        
    }
    
    @IBAction private func tappedCurrentLocation(_ sender: UIButton) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            searchTextField.text = ""
            getCurrentWeather()
        } else {
            guard let appSettingURl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(appSettingURl) {
                UIApplication.shared.open(appSettingURl, options: [:], completionHandler: nil)
            }
        }
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
        if let city: String = searchTextField.text {
            if !city.isEmpty {
                getWeatherByCity()
            }
        }
    }
}

// MARK: - ClimateViewController: Request
extension ClimateViewController {
    func getCurrentWeather() {
        typealias Request = Climate.GetWeahterByCurrentLocation.Request
        lat = unwrapped(locationManager.location?.coordinate.latitude, with: 0)
        lon = unwrapped(locationManager.location?.coordinate.longitude, with: 0)
        let request: Request = Request(lat: lat, lon: lon)
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
        let request: Request = Request(lat: lat, lon: lon)
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
            lat = unwrapped(weatherData.coord?.lat, with: 0)
            lon = unwrapped(weatherData.coord?.lon, with: 0)
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

// MARK: - ClimateViewController: CLLocationManagerDelegate
extension ClimateViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.lat = location.coordinate.latitude
            self.lon = location.coordinate.longitude
            getCurrentWeather()
            print("get current location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        setupLocation()
    }
}
