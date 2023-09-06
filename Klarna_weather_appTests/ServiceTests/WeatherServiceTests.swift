//
//  WeatherServiceTests.swift
//  Klarna_weather_appTests
//
//  Created by ashish sharma on 06/09/23.
//

import XCTest
import Combine

@testable import Klarna_weather_app

class WeatherServiceTests: XCTestCase {
    
    var sut: WeatherService!
    var mockNetworkLayer: MockNetworkLayer!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        
        super.setUp()
        mockNetworkLayer = MockNetworkLayer()
        sut = WeatherService(networkLayer: mockNetworkLayer)
    }
    
    override func tearDown() {
        
        sut = nil
        mockNetworkLayer = nil
        super.tearDown()
    }
    
    func testFetchTemperature_Success() {
        
        let expectedTemperature = Measurement(value: 25, unit: UnitTemperature.kelvin)
        let mockResponse = WeatherResponse(main: Main(temp: expectedTemperature.value))
        let data = try! JSONEncoder().encode(mockResponse)
        
        mockNetworkLayer.result = .success(data)
        
        let expectation = self.expectation(description: "Fetch Temperature")
        
        sut.fetchTemperature(latitude: 0.0, longitude: 0.0)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { temperature in
                
                    XCTAssertEqual(temperature, expectedTemperature)
                    expectation.fulfill()
                  })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
}

