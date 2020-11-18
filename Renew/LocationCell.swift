//
//  LocationCell.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class LocationCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    static let reuseId = "locationCell"
    
    override func layoutSubviews() {
        backgroundColor = AppColors.white
        layer.cornerRadius = AppViews.cornerRadius
    }
    
    public func configureCell(_ location: RecycleLocation) {
        guard let zipcode = location.zipcode else {
            return
        } 
            
        nameLabel.text = location.name
        addressLabel.text = "\(location.fullAddress) \(zipcode)"
        distanceLabel.text = "1 mile away"
    }
}
