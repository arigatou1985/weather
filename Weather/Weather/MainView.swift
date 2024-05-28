//
//  MainView.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import SwiftUI

@MainActor
struct MainView: View {
    @StateObject var weatherDetailsViewModel = WeatherDetailsViewModel(fetchWeatherAtCurrentLocationUseCase: WeatherDetailsViewUseCaseFactory.fetchWeatherAtCurrentLocationUseCase())
    
    var body: some View {
        TabView {
            weatherDetailsView
            searchLocationView
        }
    }
    
    private var weatherDetailsView: some View {
        WeatherDetailsView(viewModel: weatherDetailsViewModel)
            .tabItem {
                Label("Local temperature", systemImage: "thermometer.sun")
            }
    }
    
    private var searchLocationView: some View {
        SearchLocationView()
            .tabItem {
                Label("Search location", systemImage: "location.magnifyingglass")
            }
    }
    
}

#Preview {
    @State var useCase = FetchWeatherAtCurrentLocationUseCase(
        locationProvider: LocationProviderForPreview(),
        weatherRepository: WeatherRepositoryForPreview()
    )
    @State var viewModel = WeatherDetailsViewModel(fetchWeatherAtCurrentLocationUseCase: useCase)
    return MainView(weatherDetailsViewModel: viewModel)
}
