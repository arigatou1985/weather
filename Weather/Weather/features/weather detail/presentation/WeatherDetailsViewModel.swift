//
//  WeatherDetailsViewModel.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

@MainActor
class WeatherDetailsViewModel: ObservableObject {
    @Published private(set) var currentWeather: Weather?
    @Published var userSelectedWeather: Weather?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var localizedError: String?
    @Published var isPresentingSearchView = false
    
    init(fetchWeatherAtCurrentLocationUseCase: FetchWeatherAtCurrentLocationUseCase) {
        self.fetchWeatherAtCurrentLocationUseCase = fetchWeatherAtCurrentLocationUseCase
    }

    func fetchCurrentWeather() async {
        isLoading = true
        do {
            currentWeather = try await fetchWeatherAtCurrentLocationUseCase.fetchWeather()
        } catch {
            print("Error fetching current weather: \(error)")
            updateLocalizedError(with: error)
        }
        isLoading = false
    }
    
    private func updateLocalizedError(with error: Error) {
        switch error {
        case LocationError.locationServiceDisabled:
            localizedError = "Location service is disabled. Cannot get local weather data."
        case LocationError.locationUpdateNotAvailable:
            localizedError = "Location update not available."
        default:
            localizedError = error.localizedDescription
        }
    }
    
    private let fetchWeatherAtCurrentLocationUseCase: FetchWeatherAtCurrentLocationUseCase
}

extension Weather {
    var localizeTemperatureInCelcius: String {
        NumberFormatter.formatTemperature(temperature, fromUnit: .celsius, toUnit: .celsius)
    }

    var localizeTemperatureInFahrenheit: String {
        NumberFormatter.formatTemperature(temperature, fromUnit: .celsius, toUnit: .fahrenheit)
    }
}
