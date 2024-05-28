//
//  NumberFormatter.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

struct NumberFormatter {
    static func formatTemperature(_ value: Float, fromUnit: UnitTemperature, toUnit: UnitTemperature) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale.current
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        let measurement = Measurement(value: Double(value), unit: fromUnit)
        let result = formatter.string(from: measurement.converted(to: toUnit))
        return result
    }
}
