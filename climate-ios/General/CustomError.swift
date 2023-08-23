//
//  CustomError.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//

import Foundation

public class CustomError: Error {
    var statusCode: String = ""
    var code: String = ""
    var version: String = ""
    var title: String = ""
    var message: String = ""
    var storeLink: String?
    var type: CustomErrorType = .general
    
    public init() {}
    
    required public init(statusCode: String, code: String, version: String, title: String, message: String, storeLink: String? = nil, type: CustomErrorType = .general) {
        self.statusCode = statusCode
        self.code = code
        self.version = version
        self.title = title
        self.message = message
        self.storeLink = storeLink
        self.type = type
    }
}

public enum CustomErrorType {
    case general
    case forceUpdate
    case unsupportedOS
    case serviceMaintenance
    case noInternetConnection
    case defaultTest
}

extension CustomError {
    
    class var invalidJSON: CustomError {
        return CustomError(statusCode: "", code: "", version: "", title: "general_001".localize(), message: "")
    }
    
    class var noInternetConnection: CustomError {
        return CustomError(statusCode: "", code: "", version: "", title: "general_001".localize(), message: "", type: .noInternetConnection)
    }
    
    class var defaultTest: CustomError {
        return CustomError(statusCode: "", code: "", version: "", title: "", message: "", type: .defaultTest)
    }
}
