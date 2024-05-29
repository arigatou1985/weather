//
//  WeatherDetailsViewModel.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation
import Combine

@MainActor
class WeatherDetailsViewModel: ObservableObject {
    @Published private(set) var weather: Weather?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var localizedError: String?
    @Published var isPresentingSearchView = false
    @Published var userSelectedLocation: Location?
    
    init(fetchWeatherAtCurrentLocationUseCase: FetchWeatherAtLocationUseCase) {
        self.fetchWeatherAtCurrentLocationUseCase = fetchWeatherAtCurrentLocationUseCase
        
        $userSelectedLocation
            .dropFirst()
            .sink { newLocation in
                print("new location selected: \(newLocation?.name)")
            }
            .store(in: &cancellables)
        
    }
    
    func fetchCurrentWeather() async {
        isLoading = true
        do {
            weather = try await fetchWeatherAtCurrentLocationUseCase.fetchWeather()
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
    
    private let fetchWeatherAtCurrentLocationUseCase: FetchWeatherAtLocationUseCase
    private var cancellables = Set<AnyCancellable>()
}

extension Weather {
    var localizeTemperatureInCelcius: String {
        NumberFormatter.formatTemperature(temperature, fromUnit: .celsius, toUnit: .celsius)
    }
    
    var localizeTemperatureInFahrenheit: String {
        NumberFormatter.formatTemperature(temperature, fromUnit: .celsius, toUnit: .fahrenheit)
    }
}
