//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-28.
//

import XCTest
@testable import Weather

final class WeatherResponseTests: XCTestCase {

    func testCanInitWithJson() throws {
        let bundle = Bundle(for: WeatherResponseTests.self)
        let url = bundle.url(forResource: "openweather_api_sample_response", withExtension: "json")!
        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        let response = try decoder.decode(WeatherResponse.self, from: data)
        
        XCTAssertEqual(response.main.temp, 298.48)
        XCTAssertEqual(response.name, "Zocca")
        XCTAssertEqual(response.coord.lat, 44.34)
        XCTAssertEqual(response.coord.lon, 10.99)
    }
}
