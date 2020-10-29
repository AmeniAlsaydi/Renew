//
//  UITextField.swift
//  Renew
//
//  Created by Amy Alsaydi on 10/10/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addShadowToTextField(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.2
        self.layer.cornerRadius = cornerRadius
    }
}

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
