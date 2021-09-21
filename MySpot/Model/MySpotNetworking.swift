//
//  MySpotNetworking.swift
//  MySpot
//
//  Created by Kamil Pawlak on 21/09/2021.
//

import Foundation

import Foundation
import CoreLocation


struct MySpotNetworking {
    let mySpotURL = "https://api.openweathermap.org/data/2.5/weather?appid=YOURAPPID&units=metric"
    
    func fetchDataToCity(cityName: String) {
        let urlWithCity = "\(mySpotURL)&q=\(cityName)"
        performRequest(urlWithCity: urlWithCity)
    }
    
    func fetchDataToCoordinates(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlWithCoordinates = "\(mySpotURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(urlWithCity: urlWithCoordinates)
    }
        
    func performRequest (urlWithCity: String) {
        //1. Create URL
        if let url = URL(string: urlWithCity) {
            
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give task to sessin
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                   print(error!)
                    return
                }
                
                if let safeData = data {
                    if let result = self.fetchJSON(JSONData: safeData) {
                        // We have data
                    }
                }
            }
            task.resume()
            
        }
    }
    
    func fetchJSON(JSONData: Data) -> MySpotModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MySpotData.self, from: JSONData)
            let name = decodedData.name
            let temperature = decodedData.main.temp
            let description = decodedData.weather[0].description
            let country = decodedData.sys.country
            let timezone = decodedData.timezone
            let lat = decodedData.coord.lat
            let lon = decodedData.coord.lon
            let id = decodedData.weather[0].id
            let sunrise = decodedData.sys.sunrise
            let sunset = decodedData.sys.sunset
            
            let mySpotModel = MySpotModel(name: name, temperature: temperature, timezone: timezone, country: country, weatherDestcription: description, conditionId: id, coordinateLatitude: lat, coordinateLongitude: lon, sunrise: sunrise, sunset: sunset)
            
            print(mySpotModel.condtionName)
            print(mySpotModel.conditionId)
            print(mySpotModel.coordinateLatitude)
            print(mySpotModel.coordinateLongitude)
            print(mySpotModel.country)
            print(mySpotModel.name)
            print(mySpotModel.temperature)
            print(mySpotModel.temperatureString)
            print(mySpotModel.timezone)
            print(mySpotModel.weatherDestcription)
            print(mySpotModel.sunrise)
            print(mySpotModel.sunset)
            
            return mySpotModel
            
        } catch {
            print(error)
            return nil
        }
        
    
    
    }
}
