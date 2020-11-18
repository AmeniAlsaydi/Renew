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
    
    private let circle: String = "circle"
    private let circleFill: String = "circle.fill"
    
    // TODO: I dont understand this
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    override func layoutSubviews() {
        backgroundColor = AppColors.white
        layer.cornerRadius = AppViews.cornerRadius
    }
    
    public func configureCell(_ item: AcceptedItem) {
        
        itemNameLabel.text = item.itemName
        
        if item.pickup {
            pickupImageView.image = UIImage(systemName: circleFill)
        } else {
            pickupImageView.image = UIImage(systemName: circle)
        }
        
        if item.dropoff {
            dropOffPImageView.image = UIImage(systemName: circleFill)
        } else {
            dropOffPImageView.image = UIImage(systemName: circle)
        }
        
        if let notes = item.notes { notesLabel.text = notes }
    }
}
