//
//  LocationCell.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class LocationCell: UICollectionViewCell {

    // reuseIdentifier = "locationCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func layoutSubviews() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 10 
    }
    
    public func configureCell(_ location: RecycleLocation) {
        guard let zipcode = location.zipcode else {
            return
        }
        let address = location.address ?? ""
        let city = location.city ?? ""
        let state = location.state ?? ""
        
        let fullAddress = "\(address) \(city) \(state) \(zipcode)"
            
        nameLabel.text = location.name
        addressLabel.text = fullAddress
        distanceLabel.text = "1 mile away"
    }
}
