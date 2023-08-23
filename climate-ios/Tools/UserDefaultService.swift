//
//  UserDefaultService.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import Foundation

public class UserDefaultService {
    private static var userDefaults: UserDefaults = UserDefaults.standard
    
    // MARK: - is Celsius Degree
    public static func setIsCelsius(_ isBool: Bool) {
        UserDefaults.standard.set(isBool, forKey: "isCelsius")
    }
    
    public static func getIsCelsius() -> Bool? {
        return UserDefaults.standard.bool(forKey: "isCelsius")
    }
    
    public static func clearIsCelsius() {
        UserDefaults.standard.removeObject(forKey: "isCelsius")
    }
}
