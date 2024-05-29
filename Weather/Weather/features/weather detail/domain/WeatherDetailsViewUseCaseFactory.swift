//
//  WeatherDetailsViewUseCaseFactory.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation
import Combine
import CoreLocation

class WeatherDetailsViewUseCaseFactory {
    static func fetchWeatherAtCurrentLocationUseCase() -> FetchWeatherAtCurrentLocationUseCase {
        return FetchWeatherAtCurrentLocationUseCase(
            locationProvider: CoreLocationManager(),
            weatherRepository: OpenWeatherAPI()
        )
    }
    
    static func fetchWeatherUseCase() -> FetchWeatherUseCase {
        return FetchWeatherUseCase(weatherRepository: OpenWeatherAPI())
    }
    
    static func monitorSignificantLocationChangeUseCase() -> MonitorSignificantLocationChangeUseCase {
        return MonitorSignificantLocationChangeUseCase(locationMonitor: CoreLocationManager())
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

extension CoreLocationManager: LocationMonitor {
    typealias Output = (Double, Double)
    
    var locationPublisher: AnyPublisher<(CLLocation), Never> {
        locationChange.eraseToAnyPublisher()
    }
    
    func startMonitoringLocationChanges() {
        startUpdatingLocation()
    }
}

extension StaticLocationProvider: LocationProvider {
    var locationCoordinates: GeoCoordinates {
        get async throws {
            return GeoCoordinates(
                latitude: staticLocationCoordinates.latitude,
                longitude: staticLocationCoordinates.longitude
            )
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
