//
//  OpenWeatherAPITests.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import XCTest
@testable import Weather

final class OpenWeatherAPITests: XCTestCase {
    func testFetchWeatherDataShouldReturnWeatherData() async {
        
        let mockNetworking = MockNetworking()
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            let weather = self.sampleWeatheAPIResponse()
            let data = try! JSONEncoder().encode(weather)
            return (response, data)
        }
        
        let api = OpenWeatherAPI(urlSession: mockNetworking.urlSession)
        
        do {
            let weatherData = try await api.fetchWeatherData(
                at: 59.3293,
                longitude: 18.0686
            )
            
            XCTAssertEqual(weatherData.main.temp, 16.5)
            XCTAssertEqual(weatherData.name, "Zocca")
            XCTAssertEqual(weatherData.coord.lat, 44.34)
            XCTAssertEqual(weatherData.coord.lon, 10.99)
        } catch {
            XCTFail("Should not throw error\(error)")
        }
    }
    
    func testFetchLocationsData() async {
        
        let mockNetworking = MockNetworking()
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            let locations = self.sampleLocationsAPIResponse()
            let data = try! JSONEncoder().encode(locations)
            return (response, data)
        }
        
        let api = OpenWeatherAPI(urlSession: mockNetworking.urlSession)
        
        do {
            let locationsData = try await api.fetchLocationsData(
                matching: "Vancouver"
            )
            
            XCTAssertEqual(locationsData.count, 10)
            XCTAssertEqual(locationsData[0].name, "London")
            XCTAssertEqual(locationsData[1].name, "City of London")
        } catch {
            XCTFail("Should not throw error\(error)")
        }
    }
    
    private func sampleWeatheAPIResponse() -> WeatherResponse {
        sampleAPIResponse(from: "openweather_current_weather_api_sample_response")
    }
    
    private func sampleLocationsAPIResponse() -> [LocationResponse] {
        sampleAPIResponse(from: "openweather_geo_coding_api_sample_response")
    }
    
    private func sampleAPIResponse<T>(from resource: String) -> T where T: Decodable {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: resource, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let response = try! decoder.decode(T.self, from: data)
        return response
    }
}
