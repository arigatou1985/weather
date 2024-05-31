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

final class MockLocationMonitor: @unchecked Sendable, LocationMonitor {
    
    var locationPublisher: AnyPublisher<(CLLocation), Never> {
        locationChange.eraseToAnyPublisher()
    }
    
    private let locationChange = PassthroughSubject<CLLocation, Never>()
    
    func startMonitoringLocationChanges() {
        if let location {
            setLocation(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        }
    }
    
    func setLocation(latitude: Double, longitude: Double) {
        let newLocation = CLLocation(latitude: latitude, longitude: longitude)
        location = newLocation
        DispatchQueue.main.async {
            self.locationChange.send(newLocation)
        }
    }
    
    var location: CLLocation?
}
