//
//  HourlyCollectionTableViewCell.swift
//  ProjektiIOS
//
//  Created by R-Tech on 26.2.24.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    
    
    var model = [WeatherInfo] ()
    
    
    @IBOutlet var collectionView:UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(CellController.nib(), forCellWithReuseIdentifier:CellController.Identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static let identifier = "HourlyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
    
    func configure(with model:[WeatherInfo]) {
        self.model = model
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:100,height:100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellController.Identifier, for: indexPath) as! CellController
        cell.configure(with: model[indexPath.row])
        return cell
    }
}
