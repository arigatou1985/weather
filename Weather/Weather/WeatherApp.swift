//
//  WeatherApp.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            if isProduction {
                MainView()
            }
        }
    }
    private var isProduction: Bool {
        NSClassFromString("XCTest") == nil
    }
}
