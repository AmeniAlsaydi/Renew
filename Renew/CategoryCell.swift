//
//  CategoryCell.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
    }
    
    public func configureCell(category: Category) {
        categoryLabel.text = category.materialType
    }
    
}
