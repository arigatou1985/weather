//
//  SearchLocationViewUseCaseFactory.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

class SearchLocationViewUseCaseFactory {
    static func searchLocationUseCase() -> SearchLocationUseCase {
        let locationRepository = OpenWeatherAPI()
        return SearchLocationUseCase(locationRepository: locationRepository)
    }
}

extension OpenWeatherAPI: LocationRepository {
    func fetchLocations(matching term: String) async throws -> [Location] {
        // let locations = try await fetchLocationsData(matching: term)
        // return locations
        return []
    }
}