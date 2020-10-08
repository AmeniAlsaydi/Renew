//
//  WalkViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 10/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    // MARK:- Outlets
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 10
            nextButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var skipButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
