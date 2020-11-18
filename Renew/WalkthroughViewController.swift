//
//  WalkViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 10/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var nextButton: UIButton!

    var walkthroughPageViewController: WalkthroughPageViewController? /// this is the property that stores reference to the WalkthroughPageViewController - is used to find current index of Walkthrough screen

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addShadowToView(cornerRadius: AppViews.cornerRadius)
    }

    /// NOTE: the container view connects with the WalkthroughPageViewController through an embed segue, we can add the prepare method to get the reference of the WalkthroughPageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self /// set delegate
        }
    }

    private func updateUI() {
        /// update next and skip buttons when at end of onboarding 
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle("GET STARTED", for: .normal)
                skipButton.isHidden = true
            default:
                break
            }

            pageControl.currentPage = index  /// update page control
        }
    }
    
    /// we need to store stages that indicates whether the user has viewed the walk through.
    /// we used user defaults to store this information (if reached end/skipped on boarding - we set "hasViewedWalkthrough"  to true
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        /// preform different action depending on the current index
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewController?.fowardPage() /// call forwardPage method to display next page
            case 2:
                UserDefaults.standard.setValue(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil) /// dismiss
            default:
                break
            }
        }
        updateUI()
    }
}

extension WalkthroughViewController: WalkthroughPageViewControllerDelegate {
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}
