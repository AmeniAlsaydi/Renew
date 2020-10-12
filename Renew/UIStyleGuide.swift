//
//  UIStyleGuide.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import UIKit

/*
 Goal here is to:
 1. To create accessible fonts:
    Source for dynamic font size: https://www.hackingwithswift.com/example-code/uikit/how-to-use-dynamic-type-to-resize-your-apps-text
 2. One source for app colors
 */

class AppColors {
    // Gradient (maybe)
    static let colors = AppColors()
    
    static let white: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let lightGreen: UIColor = #colorLiteral(red: 0.7058743834, green: 0.8751116395, blue: 0.8098524213, alpha: 1)
    static let darkGreen: UIColor = #colorLiteral(red: 0.08992762119, green: 0.6527115107, blue: 0.6699190736, alpha: 0.7905607877)
    // #colorLiteral(red: 0.09117440134, green: 0.6973647475, blue: 0.7077778578, alpha: 1)
    private init() {}
    //MARK:- reserve gradients for small ui views only
    public func gradientBackground(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = [AppColors.lightGreen.cgColor, AppColors.darkGreen.cgColor, AppColors.white.cgColor]
        view.backgroundColor = .clear
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

class AppFonts {
    
}

class AppRoundedViews {
    static let cornerRadius: CGFloat = 10
}
