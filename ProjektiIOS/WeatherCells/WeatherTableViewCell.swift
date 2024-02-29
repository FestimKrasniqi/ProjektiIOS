//
//  WeatherTableViewCell.swift
//  ProjektiIOS
//
//  Created by R-Tech on 26.2.24.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel:UILabel!
    @IBOutlet var highTempLabel:UILabel!
    @IBOutlet var lowTempLabel:UILabel!
    @IBOutlet var iconImage:UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }

    func configure(with model:WeatherInfo) {
        
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        
        
        self.lowTempLabel.text = "\(Int(model.main.tempMin - 273.15))º"
        self.highTempLabel.text = "\(Int(model.main.tempMax - 273.15))º"
        self.iconImage.image = UIImage(named: "Sun")
        self.iconImage.contentMode = .scaleAspectFit
        
        if let date = getDateFromDateString(model.dtTxt) {
                // Format the date as required
                self.dayLabel.text = getDayForDate(date)
            } else {
                self.dayLabel.text = ""
            }
        
            //var iconImageName: String?

        
        if model.weather.count >= 1 {
            let icon = model.weather[0].main.lowercased()
           
            if icon.contains("clear") {
                self.iconImage.image = UIImage(named:"Sun")
            } else if icon.contains("clouds") {
                self.iconImage.image = UIImage(named:"Cloud")
            } else if icon.contains("rain") {
                self.iconImage.image = UIImage(named:"Rain")
            } else if icon.contains("snow") {
                self.iconImage.image = UIImage(named:"Snow")
            } else {
                self.iconImage.image = UIImage(named:"Sun")
            }
        } else {
            
            self.iconImage.image = UIImage(named:"Sun")
           

        }
        
    }
    
    func getDateFromDateString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dateString)
    }

    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
    }
  
    
}
