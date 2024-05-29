//
//  PreviewLocationProvider.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

struct PreviewLocationProvider: LocationProvider {
    var locationCoordinates: GeoCoordinates {
        GeoCoordinates(latitude: 59.3253311, longitude: 18.066506)
    }
}
