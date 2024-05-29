//
//  WeatherDetailsViewUseCaseFactory.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

class WeatherDetailsViewUseCaseFactory {
    static func fetchWeatherAtCurrentLocationUseCase() -> FetchWeatherAtLocationUseCase {
        return FetchWeatherAtLocationUseCase(
            locationProvider: CoreLocationManager(),
            weatherRepository: OpenWeatherAPI()
        )
    }
}

extension CoreLocationManager: LocationProvider {
    var locationCoordinates: GeoCoordinates {
        get async throws {
            let location = try await getCurrentLocation()
            return GeoCoordinates(latitude: location.latitude, longitude: location.longitude)
        }
    }
}

extension OpenWeatherAPI: WeatherRepository {
    func fetchWeather(at latitude: Double, longitude: Double) async throws -> Weather {
        let response = try await fetchWeatherData(at: latitude, longitude: longitude)
        return Weather(
            temperature: response.main.temp,
            temperatureUnit: .celsius,
            geoCoordinates: GeoCoordinates(
                latitude: response.coord.lat, 
                longitude: response.coord.lon
            ),
            locationName: response.name
        )
    }
}
