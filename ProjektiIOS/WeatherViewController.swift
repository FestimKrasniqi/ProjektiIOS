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
    
    var models = [WeatherInfo] ()
    
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
           
           let lon = currentLocation.coordinate.longitude
           let lat = currentLocation.coordinate.latitude
           
           let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=d422dc0f81e96ccfe7ce31a35819b0df"
           
           guard let url = URL(string: urlString) else {
               print("Invalid URL")
               return
           }

           let session = URLSession(configuration: .default)
           let task = session.dataTask(with: url) { data, response, error in
               guard let data = data else {
                   if let error = error {
                       print("Error: \(error)")
                   }
                   return
               }
               
               do {
                   let decoder = JSONDecoder()
                
                   let weatherData = try decoder.decode(WeatherData.self, from: data)
                   print(weatherData.list)
                   DispatchQueue.main.async {
                    self.models.append(contentsOf: weatherData.list)
                    self.table.reloadData()
                   }
               } catch {
                   print("Error decoding JSON: \(error)")
               }
           }
        task.resume()
       }

    

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier,for:indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
  
}



struct WeatherData: Codable {
    let cod: String
    let message:Int
    let cnt: Int
    let list: [WeatherInfo]
    let city: CityInfo
}

struct WeatherInfo: Codable {
    let dt: Int
    let main: MainInfo
    let weather: [WeatherDetail]
    let clouds: CloudInfo
    let wind: WindInfo
    let visibility: Int
    let pop: Double
    let sys: SysInfo
    let dtTxt: String

    private enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
    }
}

struct MainInfo: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let groundLevel: Int
    let humidity: Int
    let tempKf: Double

    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct WeatherDetail: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct CloudInfo: Codable {
    let all: Int
}

struct WindInfo: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct SysInfo: Codable {
    let pod: String
}

struct CityInfo: Codable {
    let id: Int
    let name: String
    let coord: CoordInfo
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

struct CoordInfo: Codable {
    let lat: Double
    let lon: Double
}


