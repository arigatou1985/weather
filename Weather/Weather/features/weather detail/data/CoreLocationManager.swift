//
//  CoreLocationManager.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import CoreLocation
import AsyncLocationKit
import Combine

enum LocationError: Error {
    case locationServiceDisabled
    case locationUpdateNotAvailable
}

final class CoreLocationManager: @unchecked Sendable {
    private(set) var locationChange = PassthroughSubject<CLLocation, Never>()
    
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
    
    func startUpdatingLocation() {
        locationChangeMonitoringTask = Task {
            for await locationUpdateEvent in await asyncLocationManager.startUpdatingLocation() {
                switch locationUpdateEvent {
                case .didUpdateLocations(let locations):
                    guard let lastLocation = locations.last else { continue }
                    
                    locationChange.send(lastLocation)
                    
                case .didFailWith(let error):
                    print("location update error: \(error)")
                    continue
                case .didPaused, .didResume:
                    print("location update didPaused or didResume")
                    continue
                }
            }
        }
    }
    
    func stopUpdatingLocation() {
        locationChangeMonitoringTask = nil
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
    private var locationChangeMonitoringTask: Task<(), Never>? = nil
}
