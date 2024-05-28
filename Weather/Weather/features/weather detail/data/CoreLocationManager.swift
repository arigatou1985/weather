//
//  CoreLocationManager.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import CoreLocation
import AsyncLocationKit

enum LocationError: Error {
    case locationServiceDisabled
    case locationUpdateNotAvailable
}

final class CoreLocationManager: Sendable {
    func getCurrentLocation() async throws -> (latitude: Double, longitude: Double) {
        let permission = await self.asyncLocationManager.requestPermission(with: .whenInUsage)
        guard permission == .authorizedAlways || permission == .authorizedWhenInUse else {
            throw LocationError.locationServiceDisabled
        }
        
        var updateEvent: LocationUpdateEvent?
        do {
            updateEvent = try await asyncLocationManager.requestLocation()
        } catch (let error) {
            print("Cannot request location, error: \(error)")
            throw LocationError.locationUpdateNotAvailable
        }
        
        let location = try extractLocationFrom(updateEvent: updateEvent)
        
        return (
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
    
    private func extractLocationFrom(updateEvent: LocationUpdateEvent?) throws -> CLLocation {
        switch updateEvent {
        case .didUpdateLocations(let locations):
            let location = locations.last
            guard let location else { throw LocationError.locationUpdateNotAvailable }
            return location
        case .didFailWith(let error):
            throw error
        case .didPaused, .didResume:
            throw LocationError.locationUpdateNotAvailable
        case .none:
            throw LocationError.locationUpdateNotAvailable
        }
    }
    
    private let asyncLocationManager = AsyncLocationManager(desiredAccuracy: .hundredMetersAccuracy)
}

extension AsyncLocationManager: @unchecked Sendable {}

