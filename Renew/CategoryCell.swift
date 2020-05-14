//
//  CategoryCell.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
        // add shadow here ?
        //categoryImage.clipsToBounds = true
    }
    
    public func configureCell(category: Category) {
        categoryLabel.text = category.materialType
        // categoryImage.kf.setImage(with: URL(string: category.imageURL))
        categoryImage.image = UIImage(named: category.materialType)
        
    }
    
}
