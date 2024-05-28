//
//  MainView.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            weatherDetailsView
            searchLocationView
        }
    }
    
    private var weatherDetailsView: some View {
        WeatherDetailsView()
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
    MainView()
}
