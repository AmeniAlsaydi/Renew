//
//  AccetpedItemCell.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/8/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class AccetpedItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var pickupImageView: UIImageView!
    @IBOutlet weak var dropOffPImageView: UIImageView!
    
    
    public func configureCell(_ item: AcceptedItem) {
        
        itemNameLabel.text = item.itemName
        guard let notes = item.notes else { return }
        notesLabel.text = notes
        
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
    }
}
