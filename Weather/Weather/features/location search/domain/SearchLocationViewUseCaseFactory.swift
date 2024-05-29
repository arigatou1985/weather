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
    func fetchLocations(matching term: String) async throws -> [SearchedLocation] {
        let locations = try await fetchLocationsData(matching: term)
        return locations.map {
            SearchedLocation(
                latitude: $0.lat,
                longitude: $0.lon,
                name: $0.fullName
            )
        }
    }
}

private extension LocationResponse {
    var fullName: String {
        [name, state, country].compactMap{$0}.joined(separator: ", ")
    }
}
