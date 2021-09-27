//
//  MySpotNetworking.swift
//  MySpot
//
//  Created by Kamil Pawlak on 21/09/2021.
//

import Foundation
import CoreLocation

protocol MySpotNetworkingDelegate {
    // thisIsFrom: MySpotNetworking - this is a convention to realize - from where is the data when we call didUpdate
    func didUpdate(_ thisIsFrom: MySpotNetworking, mySpotModel: MySpotModel)
}

struct MySpotNetworking {
    
    //we use delegate pattern so we can be able to reuse this struct in different project
    var delegate: MySpotNetworkingDelegate?
    
    // We have to put our private app id to this string
    let mySpotURL = "https://api.openweathermap.org/data/2.5/weather?appid=YOURAPPID&units=metric"
    
    //We can fetch data typing the name of the city
    func fetchDataToCity(cityName: String) {
        let urlWithCity = "\(mySpotURL)&q=\(cityName)"
        performRequest(urlWithCity)
    }
    //We can fetch data by pressing the location Button
    func fetchDataToCoordinates(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlWithCoordinates = "\(mySpotURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(urlWithCoordinates)
    }
        
    func performRequest (_ urlWithCity: String) {
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
                        // In this place we run our delegate with data (result).
                        self.delegate?.didUpdate(self, mySpotModel: result)
                    }
                }
            }
            task.resume()
        }
    }
    // We Decode thata form JSON to our model (MySpotModel)
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
            
            return mySpotModel
            
        } catch {
            print(error)
            return nil
        }
        
    
    
    }
}
