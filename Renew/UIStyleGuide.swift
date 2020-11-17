//
//  UIStyleGuide.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import UIKit

class AppColors {
    // Gradient (maybe)
    static let colors = AppColors()
    
    static let white: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let lightGreen: UIColor = #colorLiteral(red: 0.7058743834, green: 0.8751116395, blue: 0.8098524213, alpha: 1)
    static let darkGreen: UIColor = #colorLiteral(red: 0.08992762119, green: 0.6527115107, blue: 0.6699190736, alpha: 0.7905607877)
    static let gray: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    
    private init() {}

    // TODO: if not using removing
    // MARK: reserve gradients for small ui views only
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
    static let title1 = UIFont.preferredFont(forTextStyle: .title1)
    static let title2 = UIFont.preferredFont(forTextStyle: .title2)
    static let title3 = UIFont.preferredFont(forTextStyle: .title3)
    static let largeTitle = UIFont.preferredFont(forTextStyle: .largeTitle)
    
    static let headline = UIFont.preferredFont(forTextStyle: .headline)
    static let subheadline = UIFont.preferredFont(forTextStyle: .subheadline)
    static let body = UIFont.preferredFont(forTextStyle: .body)
    
    static let footnote = UIFont.preferredFont(forTextStyle: .footnote)
    static let caption1 = UIFont.preferredFont(forTextStyle: .caption1)
    static let caption2 = UIFont.preferredFont(forTextStyle: .caption2)
}

class AppRoundedViews {
    static let cornerRadius: CGFloat = 10
}
