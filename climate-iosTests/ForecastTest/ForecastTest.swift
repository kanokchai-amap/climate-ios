//
//  ForecastTest.swift
//  climate-iosTests
//
//  Created by Kanokchai Amaphut on 24/8/2566 BE.
//

import XCTest
@testable import climate_ios

final class ForecastTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSendLatLon_toGetForecastData_willSuccess() throws {
        
        // Given
        let interactor: ForecastInteractor = ForecastInteractor()
        let presenter: ForecastPresenterSpy = ForecastPresenterSpy()
        interactor.presenter = presenter
        
        let worker: ForecastWorkerSpy = ForecastWorkerSpy()
        interactor.worker = worker
        worker.isRetureSuccess = true
        
        typealias Request = Forecast.FiveDaysWeather.Request
        let request: Request = Request(lat: 100, lon: 40)
        
        // When
        interactor.getForecastWeather(request: request)
        
        // Then
        XCTAssert(presenter.stateCall.callLoading == 0, "call loading don't work")
        XCTAssert(presenter.stateCall.callSuccess == 1, "call success")
        XCTAssert(presenter.stateCall.callError == 0, "call error don't work")
        XCTAssert(presenter.forecastWeatherModel != nil, "response data is nil")
    }
    
    func testSendLatLon_toGetForecastData_willError() throws {
        
        // Given
        let interactor: ForecastInteractor = ForecastInteractor()
        let presenter: ForecastPresenterSpy = ForecastPresenterSpy()
        interactor.presenter = presenter
        
        let worker: ForecastWorkerSpy = ForecastWorkerSpy()
        interactor.worker = worker
        worker.isRetureSuccess = false
        
        typealias Request = Forecast.FiveDaysWeather.Request
        let request: Request = Request(lat: 100, lon: 40)
        
        // When
        interactor.getForecastWeather(request: request)
        
        // Then
        XCTAssert(presenter.stateCall.callLoading == 0, "call loading don't work")
        XCTAssert(presenter.stateCall.callSuccess == 0, "call success don't work")
        XCTAssert(presenter.stateCall.callError == 1, "call error")
        XCTAssert(presenter.forecastWeatherModel == nil, "response data isn't nil")
        XCTAssert(presenter.responseError?.type == .defaultTest, "show response error")
    }
    
    func testGetSendData_toDataStore_willGetData() throws {
        
        // Given
        let interactor: ForecastInteractor = ForecastInteractor()
        let presenter: ForecastPresenterSpy = ForecastPresenterSpy()
        interactor.presenter = presenter
        
        interactor.lat = 100
        interactor.lon = 40
        
        // When
        interactor.getDataStore(request: Forecast.GetDataStore.Request())
        
        // Then
        XCTAssert(presenter.lat == 100, "get data store is success")
        XCTAssert(presenter.lon == 40, "get data store is success")
    }
}
