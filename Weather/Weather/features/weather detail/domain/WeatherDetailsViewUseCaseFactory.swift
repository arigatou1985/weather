//
//  WeatherDetailsViewUseCaseFactory.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

class WeatherDetailsViewUseCaseFactory {
    static func fetchWeatherAtCurrentLocationUseCase() -> FetchWeatherAtCurrentLocationUseCase {
        return FetchWeatherAtCurrentLocationUseCase(
            locationProvider: CoreLocationManager(),
            weatherRepository: OpenWeatherAPI()
        )
    }
}

extension CoreLocationManager: LocationProvider {
    var currentLocation: GeoCoordinates {
        get async throws {
            return GeoCoordinates(latitude: 33.4, longitude: 18.3)
        }
    }
}

extension OpenWeatherAPI: WeatherRepository {
    func fetchWeather(at latitude: Double, longitude: Double) async throws -> Weather {
        return Weather(
            temperature: 17.2,
            temperatureUnit: .celsius,
            geoCoordinates: GeoCoordinates(
                latitude: latitude,
                longitude: longitude
            ),
            locationName: "Stockholm"
        )
    }
}
