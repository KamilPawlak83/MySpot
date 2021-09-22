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
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mySpotNetworking.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationButonPressed(_ sender: UIButton) {
    }
    
  
    
    
}

//MARK: - MySpotNetworkingDelegate Section
extension ViewController: MySpotNetworkingDelegate {
    
    func didUpdate(_ thisIsFrom: MySpotNetworking, mySpotModel: MySpotModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(mySpotModel.temperatureString)"
            self.conditionImage.image = UIImage(systemName: mySpotModel.conditionName)
            self.cityLabel.text = mySpotModel.name
            self.sunriseLabel.text = String(mySpotModel.sunrise)
            self.sunsetLabel.text = String(mySpotModel.sunset)
            self.latitudeLabel.text = String(mySpotModel.coordinateLatitude)
            self.longitudeLabel.text = String(mySpotModel.coordinateLongitude)
            self.countryLabel.text = mySpotModel.country
            self.timeZoneLabel.text = String(mySpotModel.timezone)
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

func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
{
    print(error)
}
}

//MARK: - UITextFieldDelegate Section
extension ViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    if searchTextField.text != "" {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    } else {
        searchTextField.placeholder = "Type Something1" // for test
    }
}

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    print(searchTextField.text!)
    searchTextField.endEditing(true)
    return true
}

func textFieldDidEndEditing(_ textField: UITextField) {
    if let city = searchTextField.text {
        mySpotNetworking.fetchDataToCity(cityName: city)
    }
    searchTextField.text = ""
    searchTextField.placeholder = "Search"
    
}
func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
        return true
    } else { textField.placeholder = "Type Something2" // for test
        return false
    }
}
}

