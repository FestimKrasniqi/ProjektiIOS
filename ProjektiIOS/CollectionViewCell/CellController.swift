//
//  CollectionViewCellCollectionViewController.swift
//  ProjektiIOS
//
//  Created by R-Tech on 29.2.24.
//

import UIKit



class CellController: UICollectionViewCell {
    
    
    
    static let Identifier = "CellController"
    
    
    static func nib() -> UINib{
        return UINib(nibName: "CellController", bundle: nil)
    }
    
    @IBOutlet var iconImageView:UIImageView!
    @IBOutlet var tempLabel:UILabel!
    
   
    
    func configure(with model:WeatherInfo) {
        self.tempLabel.text = "\(Int(model.main.temp - 273.15))º"
        self.iconImageView.image = UIImage(named:"Sun")
        self.iconImageView.contentMode = .scaleAspectFit
        
        if model.weather.count >= 1 {
            let icon = model.weather[0].main.lowercased()
           
            if icon.contains("clear") {
                self.iconImageView.image = UIImage(named:"Sun")
            } else if icon.contains("clouds") {
                self.iconImageView.image = UIImage(named:"Cloud")
            } else if icon.contains("rain") {
                self.iconImageView.image = UIImage(named:"Rain")
            } else if icon.contains("snow") {
                self.iconImageView.image = UIImage(named:"Snow")
            } else {
                self.iconImageView.image = UIImage(named:"Sun")
            }
        } else {
            
            self.iconImageView.image = UIImage(named:"Sun")
           

        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

       
       
    
   
    
}
