//
//  AccetpedItemCell.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/8/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class AcceptedItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var pickupImageView: UIImageView!
    @IBOutlet weak var dropOffPImageView: UIImageView!
    
    override func layoutSubviews() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
    }
    
    
    public func configureCell(_ item: AcceptedItem) {
        
        itemNameLabel.text = item.itemName
        
        if item.pickup {
            pickupImageView.image = UIImage(systemName: "circle.fill")
        } else {
            pickupImageView.image = UIImage(systemName: "circle")
        }
        
        if item.dropoff {
            dropOffPImageView.image = UIImage(systemName: "circle.fill")
        } else {
            dropOffPImageView.image = UIImage(systemName: "circle")
        }
        
        if let notes = item.notes { notesLabel.text = notes }
        
    }
}
