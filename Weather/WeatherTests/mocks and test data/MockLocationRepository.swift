//
//  MockLocationRepository.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import Foundation
@testable import Weather

actor MockLocationRepository: @unchecked Sendable, LocationRepository {
    func fetchLocations(matching term: String) async throws -> [SearchedLocation] {
        if let error = error {
            throw error
        }
        
        return locations.filter { $0.name.contains(term) }
    }
    
    func setLocation(_ locations: [SearchedLocation]) {
        self.locations = locations
    }
    
    func setError(_ error: Error?) {
        self.error = error
    }
    
    let sampleLocations = [
        SearchedLocation(latitude: -123.1207, longitude: 49.2827, name: "Vancouver, BC"),
        SearchedLocation(latitude: -122.6615, longitude: 45.6387, name: "Vancouver, WA"),
        SearchedLocation(latitude: 40.7128, longitude: -74.0060, name: "New York"),
        SearchedLocation(latitude: 37.7749, longitude: -122.4194, name: "San Francisco"),
        SearchedLocation(latitude: 34.0522, longitude: -118.2437, name: "Los Angeles")
    ]
    
    private var locations = [SearchedLocation]()
    
    private var error: Error?
}
