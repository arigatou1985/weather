//
//  MockLocationProvider.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import Foundation
@testable import Weather


class MockLocationProvider: LocationProvider {
    var locationCoordinates: GeoCoordinates {
        get async throws {
            if let error = error {
                throw error
            }
            return coordinates
        }
    }
    
    func setLocationCoordinates(latitude: Double, longitude: Double) {
        coordinates = GeoCoordinates(latitude: latitude, longitude: longitude)
    }
    
    var coordinates = GeoCoordinates(latitude: 10.1, longitude: 20.1)
    
    var error: Error?
}
