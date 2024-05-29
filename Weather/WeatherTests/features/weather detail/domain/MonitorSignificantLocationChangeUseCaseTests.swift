//
//  MonitorSignificantLocationChangeUseCaseTests.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import XCTest
import CoreLocation
@testable import Weather

final class MonitorSignificantLocationChangeUseCaseTests: XCTestCase {

    func testShouldTriggerSignificantChangeCallbackUponMinimum500MetersOfChange() {
        
        let useCase = MonitorSignificantLocationChangeUseCase(locationMonitor: locationMonitor)
        
        let expectation = expectation(description: "Should trigger significant change callback")
        
        let startLocation = CLLocation(latitude: 10.2, longitude: 20.1)
        locationMonitor.location = startLocation
        
        let moveTo = CLLocation(latitude: 10.23, longitude: 20.1)
        
        useCase.startMonitoring { latitude, longitude in
            XCTAssertEqual(latitude, moveTo.coordinate.latitude)
            XCTAssertEqual(longitude, moveTo.coordinate.longitude)
            expectation.fulfill()
        }
        
        locationMonitor.setLocation(
            latitude: moveTo.coordinate.latitude,
            longitude: moveTo.coordinate.longitude
        )
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testShouldNotTriggerSignificantChangeCallbackIfLessThan500MetersOfChangeWasObserved() {
        
        let useCase = MonitorSignificantLocationChangeUseCase(locationMonitor: locationMonitor)
        
        let expectation = expectation(description: "Should trigger significant change callback")
        
        let startLocation = CLLocation(latitude: 10.2, longitude: 20.1)
        locationMonitor.location = startLocation
        
        let moveTo = CLLocation(latitude: 10.2001, longitude: 20.1)
        
        useCase.startMonitoring { latitude, longitude in
            XCTFail("Should not receive callback for minor movement")
        }
        
        locationMonitor.setLocation(
            latitude: moveTo.coordinate.latitude,
            longitude: moveTo.coordinate.longitude
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.3)
    }
    private let locationMonitor = MockLocationMonitor()
}
