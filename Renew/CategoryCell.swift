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
        backgroundColor = AppColors.lightGreen
        categoryLabel.font = AppFonts.title2.bold()
        addShadowToView(cornerRadius: AppRoundedViews.cornerRadius)
    }
    
    public func configureCell(category: Category) {
        categoryLabel.text = category.materialType
        categoryImage.image = UIImage(named: category.materialType)
    }
}
