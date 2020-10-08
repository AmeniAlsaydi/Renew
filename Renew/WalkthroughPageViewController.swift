//
//  WalkthroughPageViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 10/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController {
    
    
    //MARK:- Properties
    var pageHeadings = ["A", "B", "C"]
    var pageSubheadings = [ "A-Sub", "B-Sub", "C-Sub"]
    var pageImages = ["Electronic", "recycleHouse", "recycle"]
    
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        /// set the data source of uipageviewcontroller to itself
        dataSource = self
        
        // Create first walkthrough screen when first loaded
        if let startingViewController = contentViewController(at: 0) {
            /// the setViewControllers method expects an array
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    /// contentViewController: helper method that is designed to create the page content VC on demand
    /// takes in the index parameter and creates the corresponding page content controller
    private func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        /// index out of range
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        /// Otherwise we create new VC and pass suitable data
        
        let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        // to instanciate an instance of VC using storyboard
            // 1. create instance of storyboard
            // 2. storyboard id is used as reference to create VC instance
            // note: the method returns a generic VC so we downcast to desired VC type
        if let pageContentViewController = storyboard.instantiateViewController(identifier: "WalkthroughContentViewController")  as? WalkthroughContentViewController {
            /// following the instaniating we assign  with specific properties
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subheading = pageSubheadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }

}

// MARK: - Page view controller datasource

extension WalkthroughPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index /// get current VC index depending on method
        index -= 1 /// decrement
        
        return contentViewController(at: index) /// and return the VC to display
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
}



