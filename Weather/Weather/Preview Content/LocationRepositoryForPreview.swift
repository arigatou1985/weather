//
//  LocationRepositoryForPreview.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

struct LocationRepositoryForPreview: LocationRepository {
    typealias Location = LocationSearchDomain.Location
    func fetchLocations(matching term: String) async throws -> [Location] {
        return [
            Location(latitude: 51.5281799, longitude: -0.4312057, name: "Preview location London"),
            Location(latitude: 34.0200393, longitude: -118.7413474, name: "Preview location Los Angeles"),
            Location(latitude: 59.325726, longitude: 17.6524495, name: "Preview location Stockholm"),
        ].filter { location in
            return location.name.lowercased().contains(term.lowercased())
        }
    }
}
