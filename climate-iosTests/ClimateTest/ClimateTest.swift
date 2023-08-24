//
//  ClimateTest.swift
//  climate-iosTests
//
//  Created by Kanokchai Amaphut on 24/8/2566 BE.
//

import XCTest
@testable import climate_ios

final class ClimateTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserDefaultService.clearIsCelsius()
    }
    
    func testSendLatLon_toGetCurrentWeather_willSuccess() throws {
        
        // Given
        let interactor: ClimateInteractor = ClimateInteractor()
        let presenter: ClimatePresenterSpy = ClimatePresenterSpy()
        interactor.presenter = presenter
        
        let worker: ClimateWorkerSpy = ClimateWorkerSpy()
        interactor.worker = worker
        worker.isRetureSuccess = true
        
        typealias Request = Climate.GetWeahterByCurrentLocation.Request
        let request: Request = Request(lat: 100, lon: 40)
        
        // When
        interactor.getCurrentWeather(request: request)
        
        // Then
        XCTAssert(presenter.stateCall.callSuccess == 1, "call success")
        XCTAssert(presenter.stateCall.callError == 0, "call error don't work")
        XCTAssert(presenter.weatherModel != nil, "response data isn't nil")
    }
    
    func testSendLatLon_toGetCurrentWeather_willError() throws {
        
        // Given
        let interactor: ClimateInteractor = ClimateInteractor()
        let presenter: ClimatePresenterSpy = ClimatePresenterSpy()
        interactor.presenter = presenter
        
        let worker: ClimateWorkerSpy = ClimateWorkerSpy()
        interactor.worker = worker
        worker.isRetureSuccess = false
        
        typealias Request = Climate.GetWeahterByCurrentLocation.Request
        let request: Request = Request(lat: 100, lon: 40)
        
        // When
        interactor.getCurrentWeather(request: request)
        
        // Then
        XCTAssert(presenter.stateCall.callSuccess == 0, "call success don't work")
        XCTAssert(presenter.stateCall.callError == 1, "call error")
        XCTAssert(presenter.weatherModel == nil, "response data isn't nil")
        XCTAssert(presenter.responseError?.type == .defaultTest, "show response error")
    }
    
    func testSendCityName_toGetCurrentWeather_willSuccess() throws {
        
        // Given
        let interactor: ClimateInteractor = ClimateInteractor()
        let presenter: ClimatePresenterSpy = ClimatePresenterSpy()
        interactor.presenter = presenter
        
        let worker: ClimateWorkerSpy = ClimateWorkerSpy()
        interactor.worker = worker
        worker.isRetureSuccess = true
        
        typealias Request = Climate.GetWeahterByCity.Request
        let request: Request = Request(q: "London")
        
        // When
        interactor.getWeatherByCity(request: request)
        
        // Then
        XCTAssert(presenter.stateCall.callSuccess == 1, "call success")
        XCTAssert(presenter.stateCall.callError == 0, "call error don't work")
        XCTAssert(presenter.weatherModel != nil, "response data isn't nil")
    }
    
    func testSendCityName_toGetCurrentWeather_willError() throws {
        
        // Given
        let interactor: ClimateInteractor = ClimateInteractor()
        let presenter: ClimatePresenterSpy = ClimatePresenterSpy()
        interactor.presenter = presenter
        
        let worker: ClimateWorkerSpy = ClimateWorkerSpy()
        interactor.worker = worker
        worker.isRetureSuccess = false
        
        typealias Request = Climate.GetWeahterByCity.Request
        let request: Request = Request(q: "London")
        
        // When
        interactor.getWeatherByCity(request: request)
        
        // Then
        XCTAssert(presenter.stateCall.callSuccess == 0, "call success don't work")
        XCTAssert(presenter.stateCall.callError == 1, "call error")
        XCTAssert(presenter.weatherModel == nil, "response data isn't nil")
        XCTAssert(presenter.responseError?.type == .defaultTest, "show response error")
    }
    
    func testChangeUnitDegree_toTemperature_willUnitDegree() throws {
        
        // Given
        let interactor: ClimateInteractor = ClimateInteractor()
        let presenter: ClimatePresenterSpy = ClimatePresenterSpy()
        interactor.presenter = presenter
        
        typealias Request = Climate.ChangeUnitDegree.Request
        let request: Request = Request(isCelsius: true)
        
        // When
        interactor.changeUnitsDegree(request: request)
        
        // Then
        XCTAssert(UserDefaultService.getIsCelsius() == true, "Change unit degree is complete")
    }
    
    func testSendData_toRouteToForecast_willSetDataStore() throws {
        
        // Given
        let interactor: ClimateInteractor = ClimateInteractor()
        let presenter: ClimatePresenterSpy = ClimatePresenterSpy()
        interactor.presenter = presenter
        
        typealias  Request = Climate.RouteToForecast.Request
        let request: Request = Request(lat: 100, lon: 40)
        
        // When
        interactor.routeToForecast(request: request)
        
        // Then
        XCTAssert(interactor.lat == 100, "lat is correct")
        XCTAssert(interactor.lon == 40, "lon is correct")
    }
}
