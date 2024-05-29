//
//  FetchWeatherUseCase.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-29.
//

import Foundation

actor FetchWeatherUseCase {
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }

    func fetchWeather(at locationCoordinates: GeoCoordinates) async throws -> Weather {
        return try await weatherRepository.fetchWeather(
            at: locationCoordinates.latitude,
            longitude: locationCoordinates.longitude
        )
    }
}
