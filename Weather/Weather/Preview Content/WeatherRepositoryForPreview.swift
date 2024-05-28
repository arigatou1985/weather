//
//  WeatherRepositoryForPreview.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

struct WeatherRepositoryForPreview: WeatherRepository {
    func fetchWeather(at latitude: Double, longitude: Double) async throws -> Weather {
        Weather(
            temperature: 25.1,
            temperatureUnit: .celsius,
            geoCoordinates: GeoCoordinates(latitude: latitude, longitude: longitude), 
            locationName: "Stockholm"
        )
    }
}
