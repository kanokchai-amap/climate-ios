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
    @IBOutlet private var dateTimeLabel: UILabel!
    @IBOutlet private var minMaxDegreeLabel: UILabel!
    @IBOutlet private var chagneDegreeButton: UIButton!
    
    var isCelsius: Bool = unwrapped(UserDefaultService.getIsCelsius(), with: false)
    
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
        setupDataDegree()
    }
  
    // MARK: Function
    private func setupView() {
        chagneDegreeButton.layer.cornerRadius = 10
        searchTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedBackgroud))
        mainLayoutView.addGestureRecognizer(tap)
    }
    
    private func setupDataDegree() {
        print(isCelsius)
        if isCelsius {
            degreeLabel.text = "30°C"
            minMaxDegreeLabel.text = "H: 31°C L:24°C"
        } else {
            degreeLabel.text = "30°F"
            minMaxDegreeLabel.text = "H: 31°F L:24°F"
        }
        UserDefaultService.setIsCelsius(isCelsius)
    }
    
    @IBAction private func tappedCurrentLocation(_ sender: UIButton) {
        getCurrentWeather()
    }
    
    @IBAction private func tappedForecast(_ sender: UIButton) {
        self.router?.routeToForecast()
    }
    
    @IBAction private func tappedChangDegree(_ sender: UIButton) {
        isCelsius = !isCelsius
        setupDataDegree()
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
        if let city: String = textField.text {
            getWeatherByCity()
        }
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
        let request: Request = Request(q: "London")
        interactor?.getWeatherByCity(request: request)
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
        case .error(let error):
            self.stopLoading()
            DialogView.showDialog(error: error.customError)
        default:
            break
        }
    }
}
