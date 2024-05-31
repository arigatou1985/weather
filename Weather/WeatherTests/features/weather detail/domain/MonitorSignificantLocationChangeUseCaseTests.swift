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

    func testShouldTriggerSignificantChangeCallbackUponMinimum500MetersOfChange() async {
        
        let useCase = MonitorSignificantLocationChangeUseCase(locationMonitor: locationMonitor)
        
        let expectation = expectation(description: "Should trigger significant change callback")
        
        let startLocation = CLLocation(latitude: 10.2, longitude: 20.1)
        let moveTo = CLLocation(latitude: 10.23, longitude: 20.1)
        
        await useCase.startMonitoring { latitude, longitude in
            XCTAssertEqual(latitude, moveTo.coordinate.latitude)
            XCTAssertEqual(longitude, moveTo.coordinate.longitude)
            expectation.fulfill()
        }
        
        await locationMonitor.setLocation(
            latitude: startLocation.coordinate.latitude,
            longitude: startLocation.coordinate.longitude
        )
        
        await locationMonitor.setLocation(
            latitude: moveTo.coordinate.latitude,
            longitude: moveTo.coordinate.longitude
        )
        
        await fulfillment(of: [expectation], timeout: 0.05)
    }
    
    func testShouldNotTriggerSignificantChangeCallbackIfLessThan500MetersOfChangeWasObserved() async {
        
        let useCase = MonitorSignificantLocationChangeUseCase(locationMonitor: locationMonitor)
        
        let expectation = expectation(description: "Should trigger significant change callback")
        
        let startLocation = CLLocation(latitude: 10.2, longitude: 20.1)
        let moveTo = CLLocation(latitude: 10.2001, longitude: 20.1)
        
        await useCase.startMonitoring { latitude, longitude in
            XCTFail("Should not receive callback for minor movement")
        }
        
        await locationMonitor.setLocation(
            latitude: startLocation.coordinate.latitude,
            longitude: startLocation.coordinate.longitude
        )
        
        await locationMonitor.setLocation(
            latitude: moveTo.coordinate.latitude,
            longitude: moveTo.coordinate.longitude
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 0.2)
    }
    private let locationMonitor = MockLocationMonitor()
}
