//
//  MySpotData.swift
//  MySpot
//
//  Created by Kamil Pawlak on 21/09/2021.
//

import Foundation

struct MySpotData: Codable {
    let name: String
    let main: Temperature
    let timezone: Int
    let sys: CountryAndSys
    let weather: [Weather]
    let coord: Coordinates
}

struct Temperature: Codable {
    let temp: Double
}

struct CountryAndSys: Codable {
    let country: String
    let sunrise: Double
    let sunset: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}
