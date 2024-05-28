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
    @Published private(set) var error: Error?
    
    init(fetchWeatherAtCurrentLocationUseCase: FetchWeatherAtCurrentLocationUseCase) {
        self.fetchWeatherAtCurrentLocationUseCase = fetchWeatherAtCurrentLocationUseCase
    }

    func fetchCurrentWeather() async {
        isLoading = true
        do {
            currentWeather = try await fetchWeatherAtCurrentLocationUseCase.fetchWeather()
        } catch {
            self.error = error
        }
        isLoading = false
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
