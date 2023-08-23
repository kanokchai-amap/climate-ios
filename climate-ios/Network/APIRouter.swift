//
//  APIRouter.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import Alamofire

enum APIRouter: URLRequestConvertible {

    case rawUrl(path: String, method: HTTPMethod, parameters: Parameters = [:])
    case getCurrentWeather(lat: String, lon: String, appId: String, units: String)
    case getForecastWeather(lat: String, lon: String, appId: String, units: String)
    case getWeatherByCity(q: String, appId: String, units: String)
    
    var method: HTTPMethod {
        switch self {
        case .rawUrl(_, let method, _):
            return method
        case .getCurrentWeather:
            return .get
        case .getForecastWeather:
            return .get
        case .getWeatherByCity:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .rawUrl(let path, _, _):
            return path
        case .getCurrentWeather, .getWeatherByCity:
            return "/weather"
        case .getForecastWeather:
            return "/forecast"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .rawUrl(_, _, let parameters):
            return parameters
        case .getCurrentWeather(let lat, let lon, let appId, let units):
            return [APIConstant.Parameter.lat: lat, APIConstant.Parameter.lon: lon, APIConstant.Parameter.appid: appId, APIConstant.Parameter.units: units]
        case .getForecastWeather(let lat, let lon, let appId, let units):
            return [APIConstant.Parameter.lat: lat, APIConstant.Parameter.lon: lon, APIConstant.Parameter.appid: appId, APIConstant.Parameter.units: units]
        case .getWeatherByCity(let q, let appId, let units):
            return [APIConstant.Parameter.q: q, APIConstant.Parameter.appid: appId, APIConstant.Parameter.units: units]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest: URLRequest
        switch self {
        case .rawUrl(let path, _, _):
            urlRequest = URLRequest(url: try path.asURL())
        default:
            var url: URL = try APIConstant.Server.baseUrl.asURL()
            url.appendPathComponent(path)
            if let parameters: Parameters = parameters,
               method == .get, let newURL: URL = url.append(parameters: parameters) {
                url = newURL
            }
            urlRequest = URLRequest(url: url)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parameters: Parameters = parameters, method != .get {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        urlRequest.headers = createHeader()
        return urlRequest
    }
    
    private func createHeader() -> HTTPHeaders {
        let token: String = ""  //unwrapped(UserDefaultService.getAccessToken(), with: "")
        let language: String = "en"
        return HTTPHeaders(["Authorization": token, "Accept-Language": language])
    }
}
