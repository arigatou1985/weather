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

actor MockLocationMonitor: @unchecked Sendable, LocationMonitor {
    init() {
        locationPublisher = locationChange.eraseToAnyPublisher()
    }
    
    let locationPublisher: AnyPublisher<(CLLocation), Never>
    
    nonisolated func startMonitoringLocationChanges() {}
    
    func setLocation(latitude: Double, longitude: Double) {
        let newLocation = CLLocation(latitude: latitude, longitude: longitude)
        self.locationChange.send(newLocation)
    }
    
    private let locationChange = PassthroughSubject<CLLocation, Never>()
}
