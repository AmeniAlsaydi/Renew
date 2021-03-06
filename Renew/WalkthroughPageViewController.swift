//
//  WalkthroughPageViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 10/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController {
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate? /// weak: to prevent memory leak
    private var pageHeadings = ["Not sure how to recycle?", "Don't know where to recycle?", "Be a friend of the earth!"]
    private var subHead1 = "Recycling is important, but it can be complicated. Learn how to properly recycle different items."
    private var subHead2 = "Search your zipcode and find near by locations to recycle your items."
    private var subHead3 = "Recylcing can be the simple change you make to play your role in preserving our beloved earth."
    
    private var pageSubheadings: [String] {
        return [subHead1, subHead2, subHead3]
    }
    private var pageImages = ["Onboarding1", "Onboarding2", "Onboarding3"]
    public var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        /// set the data source of uipageviewcontroller to itself
        dataSource = self
        delegate = self 
        
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
        guard let pageContentViewController = storyboard.instantiateViewController(identifier: "WalkthroughContentViewController")  as? WalkthroughContentViewController else {
            return nil
            
        }
        /// following the instaniating we assign  with specific properties
        pageContentViewController.imageFile = pageImages[index]
        pageContentViewController.heading = pageHeadings[index]
        pageContentViewController.subheading = pageSubheadings[index]
        pageContentViewController.index = index
        
        return pageContentViewController
    }
    
    func fowardPage() {
        currentIndex += 1
        
        /// when method is called it automatically creates the next content VC (if it can be created with current index)
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension WalkthroughPageViewController: UIPageViewControllerDataSource {
    // viewControllerBefore
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // get VC
        guard let walkThroughContentVC = viewController as? WalkthroughContentViewController else {
            fatalError("couldnt get walkThroughContentVC")
        }
        
        var index = walkThroughContentVC.index /// get current VC index depending on method
        index -= 1 /// decrement
        
        return contentViewController(at: index) /// and return the VC to display
    }
    
    // viewControllerAfter
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let walkThroughContentVC = viewController as? WalkthroughContentViewController else {
            fatalError("couldnt get walkThroughContentVC")
        }
        
        var index = walkThroughContentVC.index /// get current VC index depending on method
        index += 1
        
        return contentViewController(at: index)
    }
}

extension WalkthroughPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed { /// check if transition is completed
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index /// find out current page index
                
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: currentIndex) /// call method to inform delegate
            }
        }
    }
}
