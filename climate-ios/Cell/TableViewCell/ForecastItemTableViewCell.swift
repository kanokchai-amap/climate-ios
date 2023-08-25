//
//  ForecastItemTableViewCell.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import UIKit

class ForecastItemTableViewCell: UITableViewCell {
    
    @IBOutlet private var mainLayoutView: UIView!
    @IBOutlet private var backgroudImage: UIImageView!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var dateTimeLabel: UILabel!
    @IBOutlet private var weatherImage: UIImageView!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var degreeLabel: UILabel!
    @IBOutlet private var minMaxDegreeLabel: UILabel!
    
    let isCelsius: Bool = unwrapped(UserDefaultService.getIsCelsius(), with: false)
    var forecastWeatherData: ForecastWeatherModel = ForecastWeatherModel(from: [:])
    var weatherData: WeatherModel = WeatherModel(from: [:])
    var indexPath: IndexPath = IndexPath()

    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        mainLayoutView.layer.cornerRadius = 16
        self.selectionStyle = .none
    }
    
    func setupData() {
        let cityName: String = unwrapped(forecastWeatherData.city?.name, with: "")
        
        let temp: Int = Int(unwrapped(weatherData.main?.temp, with: 0))
        let temp_max: Int = Int(unwrapped(weatherData.main?.temp_max, with: 0))
        let temp_min: Int = Int(unwrapped(weatherData.main?.temp_min, with: 0))
        let humidity: Int = Int(unwrapped(weatherData.main?.humidity, with: 0))
        let dateTime: String = unwrapped(weatherData.dt_txt, with: "")
        
        weatherImage.image = UIImage(systemName: unwrapped(weatherData.weather?.first?.conditionName, with: ""))
        cityLabel.text = unwrapped(cityName, with: "")
        
        let fullTime: DateFormatter = DateFormatter()
        fullTime.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let date: Date = unwrapped(fullTime.date(from: dateTime), with: Date())
        
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.locale = Language.shared.current.getLocale()
        dateFormat.dateFormat = "dd/MM/yyyy, HH:mm"
        let timeStr: String = dateFormat.string(from: date)
        
        dateTimeLabel.text = timeStr

        if isCelsius {
            degreeLabel.text = "\(temp)°C"
            minMaxDegreeLabel.text = "H: \(temp_max)°C, L:\(temp_min)°C"
        } else {
            degreeLabel.text = "\(temp)°F"
            minMaxDegreeLabel.text = "H: \(temp_max)°F, L:\(temp_min)°F"
        }
        
        humidityLabel.text = "Humidity: \(humidity)"
    }
}
