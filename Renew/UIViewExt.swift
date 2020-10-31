//
//  UIViewExt.swift
//  Renew
//
//  Created by Amy Alsaydi on 10/31/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadowToView(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.4
        self.layer.cornerRadius = cornerRadius
    }
}
