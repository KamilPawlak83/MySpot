//
//  ViewController.swift
//  MySpot
//
//  Created by Kamil Pawlak on 21/09/2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
  
   
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var conditionImage: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var sunriseLabel: UILabel!
    @IBOutlet var sunsetLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var timeZoneLabel: UILabel!
    
    
    var mySpotNetworking = MySpotNetworking()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // first we have to use delegate and than request for location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mySpotNetworking.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationButonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - MySpotNetworkingDelegate Section
extension ViewController: MySpotNetworkingDelegate {
    
    func didUpdate(_ thisIsFrom: MySpotNetworking, mySpotModel: MySpotModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(mySpotModel.temperatureString) °C"
            self.conditionImage.image = UIImage(systemName: mySpotModel.conditionName)
            self.cityLabel.text = mySpotModel.name
            // Sunrise with proper date format (only time)
            let sunrise = Date(timeIntervalSince1970: mySpotModel.sunrise)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium
            self.sunriseLabel.text = dateFormatter.string(from: sunrise)
            // Sunset with proper date format (only time)
            let sunset = Date(timeIntervalSince1970: mySpotModel.sunset)
            self.sunsetLabel.text = dateFormatter.string(from: sunset)
            self.latitudeLabel.text = String(mySpotModel.coordinateLatitude)
            self.longitudeLabel.text = String(mySpotModel.coordinateLongitude)
            self.countryLabel.text = mySpotModel.country
            // We have to change data for more popular description like ( GMT -1,GMT +0, GMT +1, etc)
            let timeZone = mySpotModel.timezone / 3600
            if timeZone < 0 {
                self.timeZoneLabel.text = "GMT \(timeZone)"
            } else {
                self.timeZoneLabel.text = "GMT +\(timeZone)"
            }
         
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {

func locationManager(_ manager: CLLocationManager,
       didUpdateLocations locations: [CLLocation])
{
    if let location = locations.last {
        locationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        mySpotNetworking.fetchDataToCoordinates(latitude: lat, longitute: lon)
    }
}
//according to the documentation we need to use this didFailWithError method
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
{
    print(error)
}
}

//MARK: - UITextFieldDelegate Section
extension ViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    if searchTextField.text != "" {
        searchTextField.endEditing(true)
    } else {
        searchTextField.placeholder = "Type Something"
    }
}

// when we press return button on keyboard
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchTextField.endEditing(true)
    return true
}
// when we end editing
func textFieldDidEndEditing(_ textField: UITextField) {
    //if we have data
    if let city = searchTextField.text {
        mySpotNetworking.fetchDataToCity(cityName: city)
    }
    searchTextField.text = ""
    searchTextField.placeholder = "Search"
    
}
// if we type something and press return or search button the keyboard will hide and func textFieldDidEndEditing will start.
func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
        return true
    } else { textField.placeholder = "Type Something"
        return false
    }
}
}

