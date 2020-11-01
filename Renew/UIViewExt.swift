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

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
