//
//  MockLocationRepository.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import Foundation
@testable import Weather

final class MockLocationRepository: LocationRepository {
    func fetchLocations(matching term: String) async throws -> [SearchedLocation] {
        if let error = error {
            throw error
        }
        
        return locations.filter { $0.name.contains(term) }
    }
    
    var locations = [SearchedLocation]()
    
    var error: Error?
}
