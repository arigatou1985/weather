//
//  MockLocationMonitor.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import Foundation
import Combine
import CoreLocation
@testable import Weather

final class MockLocationMonitor: LocationMonitor {
    
    var locationPublisher: AnyPublisher<(CLLocation), Never> {
        locationChange.eraseToAnyPublisher()
    }
    
    private let locationChange = PassthroughSubject<CLLocation, Never>()
    
    func startMonitoringLocationChanges() {
        setLocation(latitude: 10.1, longitude: 20.1)
    }
    
    func setLocation(latitude: Double, longitude: Double) {
        locationChange.send(CLLocation(latitude: latitude, longitude: longitude))
    }
}
