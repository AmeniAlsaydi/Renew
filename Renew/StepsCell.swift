//
//  StepsCell.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class StepsCell: UICollectionViewCell {
    
    @IBOutlet weak var stepLabel: UILabel!
    //@IBOutlet weak var stepNumLabel: UILabel!
    
    public func configureCell(stepNum: Int, step: String) {
        stepLabel.text = step
        //stepNumLabel.text = stepNum
    }
}
