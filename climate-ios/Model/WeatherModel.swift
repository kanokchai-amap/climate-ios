//
//  CurrentWeatherModel.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import Foundation

// MARK: - ForecastWeatherModel
struct ForecastWeatherModel: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [WeatherModel]?
    let city: City?
    
    init(from json: [String: Any]) {
        self.cod = json["cod"] as? String
        self.message = json["message"] as? Int
        self.cnt = json["cnt"] as? Int
        
        if let listArray: [[String: Any]] = json["list"] as? [[String: Any]] {
            list = listArray.map({ WeatherModel(from: $0) })
        } else {
            list = []
        }
        
        if let cityData: [String: Any] = json["city"] as? [String: Any] {
            city = City(from: cityData)
        } else {
            city = nil
        }
    }
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
    
    init(from json: [String: Any]) {
        self.id = json["id"] as? Int
        self.name = json["name"] as? String
        
        if let coordData: [String: Any] = json["coord"] as? [String: Any] {
            coord = Coord(from: coordData)
        } else {
            coord = nil
        }
        
        self.country = json["country"] as? String
        self.population = json["population"] as? Int
        self.timezone = json["timeZone"] as? Int
        self.sunrise = json["sunrise"] as? Int
        self.sunset = json["sunset"] as? Int
     }
}

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
    let dt_txt: String?
    
    init(from json: [String: Any]) {
        
        if let coordData: [String: Any] = json["coord"] as? [String: Any] {
            coord = Coord(from: coordData)
        } else {
            coord = nil
        }
        
        if let weatherArray: [[String: Any]] = json["weather"] as? [[String: Any]] {
            weather = weatherArray.map({ Weather(from: $0) })
        } else {
            weather = []
        }
        
        self.base = json["base"] as? String
        
        if let mainData: [String: Any] = json["main"] as? [String: Any] {
            main = Main(from: mainData)
        } else {
            main = nil
        }
        
        self.visibility = json["visibility"] as? Int
        
        if let windData: [String: Any] = json["wind"] as? [String: Any] {
            wind = Wind(from: windData)
        } else {
            wind = nil
        }
        
        if let cloudsData: [String: Any] = json["clouds"] as? [String: Any] {
            clouds = Clouds(from: cloudsData)
        } else {
            clouds = nil
        }
        
        self.dt = json["dt"] as? Int
        
        if let sysData: [String: Any] = json["sysData"] as? [String: Any] {
            sys = Sys(from: sysData)
        } else {
            sys = nil
        }
        
        self.timezone = json["timezone"] as? Int
        self.id = json["id"] as? Int
        self.name = json["name"] as? String
        self.cod = json["cod"] as? Int
        self.dt_txt = json["dt_txt"] as? String
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
    
    init(from json: [String: Any]) {
        self.all = json["all"] as? Int
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
    
    init(from json: [String: Any]) {
        self.lon = json["lon"] as? Double
        self.lat = json["lat"] as? Double
    }
}

// MARK: - Main
struct Main: Codable {
    let temp, feels_like, temp_min, temp_max: Double?
    let pressure, humidity, sea_level, grnd_level: Int?
    let temp_kf: Double?
    
    init(from json: [String: Any]) {
        self.temp = json["temp"] as? Double
        self.feels_like = json["feels_like"] as? Double
        self.temp_min = json["temp_min"] as? Double
        self.temp_max = json["temp_max"] as? Double
        self.pressure = json["pressure"] as? Int
        self.humidity = json["humidity"] as? Int
        self.sea_level = json["sea_level"] as? Int
        self.grnd_level = json["grnd_level"] as? Int
        self.temp_kf = json["temp_kf"] as? Double
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
    let pod: String?
    
    init(from json: [String: Any]) {
        self.type = json["type"] as? Int
        self.id = json["id"] as? Int
        self.country = ["country"] as? String
        self.sunrise = json["sunrise"] as? Int
        self.sunset = json["sunset"] as? Int
        self.pod = json["pod"] as? String
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
    
    var conditionName: String {
        switch unwrapped(id, with: 0) {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    init(from json: [String: Any]) {
        self.id = json["id"] as? Int
        self.main = json["main"] as? String
        self.description = json["description"] as? String
        self.icon = json["icon"] as? String
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
    
    init(from json: [String: Any]) {
        self.speed = json["speed"] as? Double
        self.deg = json["deg"] as? Int
        self.gust = json["gust"] as? Double
    }
}
