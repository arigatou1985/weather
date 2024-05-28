//
//  MainView.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import SwiftUI

@MainActor
struct MainView: View {
    @StateObject var weatherDetailsViewModel = WeatherDetailsViewModel(
        fetchWeatherAtCurrentLocationUseCase: WeatherDetailsViewUseCaseFactory.fetchWeatherAtCurrentLocationUseCase()
    )
    
    @StateObject var searchLocationViewModel =
    SearchLocationViewModel(
        searchLocationUseCase: SearchLocationViewUseCaseFactory.searchLocationUseCase()
    )
    
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
        SearchLocationView(viewModel: searchLocationViewModel)
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
    @State var searchUseCase = SearchLocationUseCase(locationRepository: LocationRepositoryForPreview())
    @State var weatherDetailsViewModel = WeatherDetailsViewModel(fetchWeatherAtCurrentLocationUseCase: useCase)
    @State var searchLocationViewModel = SearchLocationViewModel(searchLocationUseCase: searchUseCase)
    
    return MainView(
        weatherDetailsViewModel: weatherDetailsViewModel,
        searchLocationViewModel: searchLocationViewModel
    )
}
