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
            VStack {
                weatherDescription(viewModel.weather)
                Spacer()
                errorMessage(for: viewModel.localizedError)
                Spacer()
                searchLocationButton
            }
            if (viewModel.isLoading) {
                loadingIndicator
            }
        }
        .sheet(isPresented: $viewModel.isPresentingSearchView, content: {
            locationSearchView
        })
        .task {
            await viewModel.fetchCurrentWeather()
        }
    }
    
    @ViewBuilder
    private func weatherDescription(_ weather: Weather?) -> some View {
        if let weather {
            VStack() {
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
    
    private var searchLocationButton: some View {
        Button(action: {
            viewModel.isPresentingSearchView = true
        }, label: {
            Text("Search location")
        })
        .padding()
    }
    
    private var loadingIndicator: some View {
        ProgressView {
            Text("Loading...")
        }
    }
    
    @ViewBuilder
    private var locationSearchView: some View {
        let viewModel = SearchLocationViewModel(
            searchLocationUseCase: SearchLocationViewUseCaseFactory.searchLocationUseCase(),
            onLocationSelected: { location in
                self.viewModel.userSelectedLocation = location
                self.viewModel.isPresentingSearchView = false
            }
        )
        SearchLocationView(viewModel: viewModel)
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
