//
//  SavedCell.swift
//  Renew
//
//  Created by Amy Alsaydi on 8/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Kingfisher

class SavedCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var materialLabel: UILabel!
    
    public func configureCell(item: Item) {
        itemImage.kf.setImage(with: URL(string: item.imageURL))
        itemName.text = item.itemName
        materialLabel.text = "material type"
    }
    
    
}
