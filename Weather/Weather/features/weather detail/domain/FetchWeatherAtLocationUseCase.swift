//
//  FetchWeatherAtCurrentLocationUseCase.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

protocol LocationProvider: Sendable {
    var locationCoordinates: GeoCoordinates {
        get async throws
    }
}

protocol WeatherRepository: Sendable {
    func fetchWeather(at latitude: Double, longitude: Double) async throws -> Weather
}

actor FetchWeatherAtLocationUseCase {
    private let locationProvider: LocationProvider
    private let weatherRepository: WeatherRepository
    
    init(locationProvider: LocationProvider, weatherRepository: WeatherRepository) {
        self.locationProvider = locationProvider
        self.weatherRepository = weatherRepository
    }

    func fetchWeather() async throws -> Weather {
        let location = try await locationProvider.locationCoordinates
        return try await weatherRepository.fetchWeather(at: location.latitude, longitude: location.longitude)
    }
}
