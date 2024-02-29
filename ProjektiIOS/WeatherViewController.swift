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
    var models1 = [WeatherDetail] ()
    
    var currentLocation:CLLocation?
    var current:WeatherData?
    
   
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        table.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
       
        
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
                   
                 
                       //print(weatherData.list)
                   DispatchQueue.main.async {
                    self.models.append(contentsOf: weatherData.list)
                    self.current = weatherData
                    self.table.reloadData()
                    self.table.tableHeaderView = self.createTableHeader()
                   
                   }
               } catch {
                   print("Error decoding JSON: \(error)")
               }
           }
        task.resume()
       }

    func createTableHeader() -> UIView {
      
        let headerVIew = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))

        headerVIew.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)

        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/2))

        
        
        headerVIew.addSubview(locationLabel)
        headerVIew.addSubview(tempLabel)
        headerVIew.addSubview(summaryLabel)

        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center

       

        guard let currentWeather = self.current else {
            return UIView()
        }

        locationLabel.text = currentWeather.city.name
        tempLabel.text = "\(Int(currentWeather.list[0].main.temp-273.15))°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        summaryLabel.text = self.current?.list[0].weather[0].description.uppercased()

    
        return headerVIew
    
}

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier,for:indexPath) as! WeatherTableViewCell
        cell.configure(with:models[indexPath.row])
        cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
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


