//
//  Connectivity.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import Alamofire

class Connectivity {
    
    class var isConnectedToInternet: Bool {
        return unwrapped(NetworkReachabilityManager()?.isReachable, with: false)
    }
}
