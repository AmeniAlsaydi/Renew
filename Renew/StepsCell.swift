//
//  StepsCell.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class StepsCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stepNumLabel: UILabel!
    
    
    override func layoutSubviews() {
        backgroundImage.layer.cornerRadius = backgroundImage.frame.width/2
        self.backgroundColor = .systemBackground
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,cornerRadius:self.contentView.layer.cornerRadius).cgPath
        
    }
    
    public func configureCell(stepNum: Int, step: String) {
        stepLabel.text = step
        stepNumLabel.text = "\(stepNum)"
    }
}
