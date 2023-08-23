//
//  ForecastWorker.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Alamofire

class ForecastWorker {
    
    func doSomeWork(onSuccess: @escaping (Any) -> Void, onError: @escaping (CustomError) -> Void) {
        let parameters: Parameters = [:]
        HttpNetWork().request(url: ServicePath.unspecified, method: .post, parameters: parameters, onSuccess: { (json) in
            print(json)
        }, onError: { (error) in
            onError(error)
        })
    }
}
