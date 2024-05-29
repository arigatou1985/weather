//
//  WeatherDetailsView.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import SwiftUI

struct WeatherDetailsView: View {
    @EnvironmentObject var viewModel: WeatherDetailsViewModel
    
    var body: some View {
        ZStack {
            VStack {
                weatherDescription
                Spacer()
                errorMessage
                Spacer()
                searchLocationButton
            }
            loadingIndicator
        }
        .sheet(isPresented: $viewModel.isPresentingSearchView, content: {
            locationSearchView
        })
        .onAppear {
            viewModel.fetchWeatherAtCurrentLocation()
            viewModel.startMonitoringLocationChange()
        }
    }
    
    @ViewBuilder
    private var weatherDescription: some View {
        if let weather = viewModel.weather {
            VStack() {
                Text("Weather at \(weather.locationName ?? "Unknown location")")
                    .font(.title)
                    .padding()
                if let name = viewModel.userSelectedLocation?.name {
                    Text(name)
                }
                Text("Temperature: \(weather.localizeTemperatureInCelcius) / \(weather.localizeTemperatureInFahrenheit)")
                    .padding()
            }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var errorMessage: some View {
        if let localizedError = viewModel.localizedError {
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
    
    @ViewBuilder
    private var loadingIndicator: some View {
        if (viewModel.isLoading) {
            ProgressView {
                Text("Loading...")
            }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var locationSearchView: some View {
        SearchLocationView()
    }
}

#Preview {
    return WeatherDetailsView()
        .environmentObject(PreviewViewModelFactory.searchLocationViewModel())
        .environmentObject(PreviewViewModelFactory.weatherDetailsViewModel())
}
