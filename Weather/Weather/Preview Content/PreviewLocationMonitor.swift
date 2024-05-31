//
//  PreviewLocationMonitor.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-29.
//

import Foundation
import Combine
import CoreLocation

struct PreviewLocationMonitor: @unchecked Sendable, LocationMonitor {
    
    var locationPublisher = PassthroughSubject<CLLocation, Never>().eraseToAnyPublisher()
    
    func startMonitoringLocationChanges() {
        
    }
}
