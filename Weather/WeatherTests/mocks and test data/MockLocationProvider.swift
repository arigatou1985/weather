//
//  MockLocationProvider.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import Foundation
@testable import Weather


actor MockLocationProvider: @unchecked Sendable, LocationProvider {
    var locationCoordinates: GeoCoordinates {
        get async throws {
            if let error = error {
                throw error
            }
            return coordinates
        }
    }
    
    func setCoordinates(_ coordinates: GeoCoordinates) {
        self.coordinates = coordinates
    }
    
    func setError(_ error: Error?) {
        self.error = error
    }
    
    private var coordinates = GeoCoordinates(latitude: 10.1, longitude: 20.1)
    
    private var error: Error?
}
