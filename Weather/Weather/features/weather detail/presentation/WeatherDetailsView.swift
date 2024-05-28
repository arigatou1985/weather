//
//  WeatherDetailsView.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import SwiftUI

struct WeatherDetailsView: View {
    @StateObject var viewModel: WeatherDetailsViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 100.0) {
                weatherDescription(viewModel.userSelectedWeather)
                weatherDescription(viewModel.currentWeather)
                errorMessage(for: viewModel.localizedError)
            }
            if (viewModel.isLoading) {
                ProgressView {
                    Text("Loading...")
                }
            }
        }
        .task {
            await viewModel.fetchCurrentWeather()
        }
    }
    
    @ViewBuilder
    private func weatherDescription(_ weather: Weather?) -> some View {
        if let weather {
            VStack {
                Text("Weather at \(weather.locationName ?? "Unknown location")")
                    .font(.title)
                    .padding()
                Text("Temperature: \(weather.localizeTemperatureInCelcius) / \(weather.localizeTemperatureInFahrenheit)")
                    .padding()
            }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func errorMessage(for localizedError: String?) -> some View {
        if let localizedError {
            VStack {
                Spacer()
                Text(localizedError)
                    .foregroundStyle(.red)
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    @State var useCase = FetchWeatherAtCurrentLocationUseCase(
        locationProvider: LocationProviderForPreview(),
        weatherRepository: WeatherRepositoryForPreview()
    )
    @State var viewModel = WeatherDetailsViewModel(fetchWeatherAtCurrentLocationUseCase: useCase)
    return WeatherDetailsView(viewModel: viewModel)
}
