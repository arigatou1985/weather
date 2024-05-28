//
//  SearchLocationUseCase.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

protocol LocationRepository: Sendable {
    func fetchLocations(matching term: String) async throws -> [Location]
}

actor SearchLocationUseCase {
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
    
    func searchLocations(matching term: String) async throws -> [Location] {
        print("\(Date()) search locations matching: \(term)")
        let locations = try await locationRepository.fetchLocations(matching: term)
        print("\(Date()) search locations matching: \(term) found: \(locations.count) results")
        return locations
    }
    
    private let locationRepository: LocationRepository
}
