//
//  MonitorSignificantLocationChangeUseCase.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-29.
//

import Foundation
import Combine
import CoreLocation

protocol LocationMonitor {
    var locationPublisher: AnyPublisher<CLLocation, Never> { get }
    func startMonitoringLocationChanges()
}

class MonitorSignificantLocationChangeUseCase {
    static let minimMovementForTriggerSignificantLocationChange = 500.0 // in meters
   
    init(locationMonitor: LocationMonitor) {
        self.locationMonitor = locationMonitor
    }
    
    func startMonitoring(onSignificantChange: @escaping (Double, Double) -> ()) {
        locationMonitor
            .locationPublisher
            .sink { [weak self] newLocation in
                self?.handleLocationChange(
                    newLocation: newLocation,
                    onSignificantChange: onSignificantChange
                )
            }
            .store(in: &cancellables)
        
        locationMonitor.startMonitoringLocationChanges()
    }
    
    private func handleLocationChange(newLocation: CLLocation, onSignificantChange: @escaping (Double, Double) -> ()) {
        if let currentLocation {
            let distance = currentLocation.distance(from: newLocation)
            print(">>>> handleLocationChange: \(newLocation)")
            if distance > Self.minimMovementForTriggerSignificantLocationChange {
                print("User moved \(distance) meters from the last location")
                self.currentLocation = newLocation
                let coordinates = newLocation.coordinate
                onSignificantChange(coordinates.latitude, coordinates.longitude)
            }
        } else {
            currentLocation = newLocation
        }
    }
    
    private let locationMonitor: LocationMonitor
    private var currentLocation: CLLocation?
    private var cancellables = Set<AnyCancellable>()
}
