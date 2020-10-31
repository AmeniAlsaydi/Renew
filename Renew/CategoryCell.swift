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
        backgroundColor = #colorLiteral(red: 0.7058743834, green: 0.8751116395, blue: 0.8098524213, alpha: 1)
        addShadowToView(cornerRadius: 10)
    }
    
    public func configureCell(category: Category) {
        categoryLabel.text = category.materialType
        categoryImage.image = UIImage(named: category.materialType)
    }
}
