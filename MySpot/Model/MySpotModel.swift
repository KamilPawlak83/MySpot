//
//  MySpotModel.swift
//  MySpot
//
//  Created by Kamil Pawlak on 21/09/2021.
//

import Foundation


struct MySpotModel {
    let name: String
    let temperature: Double
    let timezone: Int
    let country: String
    let weatherDestcription: String
    let conditionId: Int
    let coordinateLatitude: Double
    let coordinateLongitude: Double
    let sunrise: Double
    let sunset: Double
    
    // these are computed properties
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232: return "cloud.bolt"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "cloud.snow"
        case 701...781: return "cloud.fog"
        case 800: return "sun.max"
        case 801...884: return "cloud.bolt"
        default: return "cloud"
        }
    }
}
