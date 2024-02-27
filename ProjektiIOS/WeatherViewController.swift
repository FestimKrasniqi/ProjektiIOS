//
//  WeatherViewController.swift
//  ProjektiIOS
//
//  Created by R-Tech on 26.2.24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    @IBOutlet var table:UITableView!
    
    var models = [Weather] ()
    
    var currentLocation:CLLocation?
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    func setupLocation () {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty,currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation () {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        print(lat)
        print(long)
        
        let apiKey = "d422dc0f81e96ccfe7ce31a35819b0df"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?&appid=\(apiKey)\(lat),\(long)"
        
        

        URLSession.shared.dataTask(with: URL(string:urlString)!, completionHandler: {
            data,response,error in
            
            guard let data = data,error == nil else {
                print("Something went wrong")
                return
            }

            
            })

    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
  
}

struct Weather {
    
}
