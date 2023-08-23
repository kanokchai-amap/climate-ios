//
//  APIClient.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import Alamofire
import SwiftyJSON

final class APIClient {
    
    static let shared: APIClient = APIClient()
    
    public func request(api: APIRouter, onSuccess: @escaping (JSON) -> Void, onError: @escaping (CustomError) -> Void) {
        guard Connectivity.isConnectedToInternet else {
            onError(CustomError.noInternetConnection)
            return
        }
        AF.request(api).responseString { (response) in
            self.process(response: response, onSuccess: onSuccess, onError: onError)
        }
    }
    
    public func upload(data: Data, api: APIRouter, onSuccess: @escaping (JSON) -> Void, onProgress: @escaping (Double) -> Void, onError: @escaping (CustomError) -> Void) {
        let fileName: String = getDocumentsDirectory().appendingPathComponent("image.png").absoluteString
        guard Connectivity.isConnectedToInternet else {
            onError(CustomError.noInternetConnection)
            return
        }
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: "image/png")
        }, with: api).uploadProgress { (progress) in
            onProgress(progress.fractionCompleted)
        }.responseString { (response) in
            self.process(response: response, onSuccess: onSuccess, onError: onError)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths: [URL] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func process(response: AFDataResponse<String>, onSuccess: @escaping (JSON) -> Void, onError: @escaping (CustomError) -> Void) {
        switch response.result {
        case .success(let value):
            let json: JSON = self.stringToJSON(value)
            switch response.response?.statusCode {
            case 200:
                onSuccess(json)
            default:
                onError(createCustomErrorFrom(json: json))
            }
        case .failure(let error):
            print(error)
            onError(CustomError.noInternetConnection)
        }
    }
    
    private func stringToJSON(_ str: String) -> JSON {
        if let data: Data = str.data(using: .isoLatin1) {
            do {
                let json: JSON = try JSON(data: data)
                return json
            } catch {
                return [:]
            }
        }
        return [:]
    }
    
    private func createCustomErrorFrom(json: JSON) -> CustomError {
        let statusCode: String = json["statusCode"].stringValue
        let code: String = json["code"].stringValue
        let version: String = json["version"].stringValue
        let title: String = json["title"].stringValue
        let message: String = json["message"].stringValue
        let storeLink: String? = json["storeLink"].string
        return CustomError(statusCode: statusCode, code: code, version: version, title: title, message: message, storeLink: storeLink, type: .general)
    }
}
