//
//  Generics.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//

import Foundation

typealias completeBlock = () -> Void

public func unwrapped<T>(_ wrapped: T?, with castValue: T) -> T {
    if let unwrapped: T = wrapped {
        return unwrapped
    } else {
        return castValue
    }
}

public func chunkArray<T>(s: [T], splitSize: Int) -> [[T]] {
    if s.count <= splitSize {
        return [s]
    } else {
        return [Array<T>(s[0..<splitSize])] + chunkArray(s: Array<T>(s[splitSize..<s.count]), splitSize: splitSize)
    }
}

public enum Result<T> {
    case success(result: T)
    case failure(error: CustomError)
}

public enum UserResult<T> {
    case loading
    case success(result: T)
    case failure(error: CustomError)
}

public enum Content<T, E: Error> {
    case loading
    case empty
    case success(data: T)
    case error(error: ViewModelError<E>)
}

public struct ViewModelError<E: Error> {
    let customError: CustomError
    let `case`: E
    
    init(customError: CustomError, case: E) {
        self.customError = customError
        self.case = `case`
    }
}

public enum EmptyResult {
    case loading
    case success
    case failure(error: CustomError)
}

class ArrayWrapper<T> {
    var list: [T] = []
    
    init() {
    }
}

