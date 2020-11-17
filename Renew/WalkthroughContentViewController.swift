//
//  WalkthroughContentViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 10/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

// We use this class to support multiple walkthrough screens
// designed to display an image , heading and subheading

class WalkthroughContentViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var headinglabel: UILabel!
    @IBOutlet var subheadingLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    
    // MARK: Properties
    
    var index = 0 /// used to store current page index
    var heading = "" ///
    var subheading = ""
    var imageFile = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    
    }
    
    private func updateUI() {
        headinglabel.text = heading
        subheadingLabel.text = subheading
        contentImageView.image = UIImage(named: imageFile)
    }

}
