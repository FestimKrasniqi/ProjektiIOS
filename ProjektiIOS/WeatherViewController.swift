//
//  WeatherViewController.swift
//  ProjektiIOS
//
//  Created by R-Tech on 26.2.24.
//

import UIKit

class WeatherViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var table:UITableView!
    
    var models = [Weather] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
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
