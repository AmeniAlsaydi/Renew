//
//  LocationDetailViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

enum CardState {
    case expanded
    case collapsed
}

class LocationDetailViewController: UIViewController {
    
    static let identifier = "LocationDetailViewController"

    @IBOutlet weak var boarderView: UIView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    private let location: RecycleLocation
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?

    var childViewController: AcceptedItemsController!
    var visualEffectView: UIVisualEffectView!
    
    private var cardHeight: CGFloat!
    private let cardHandleAreaHeight: CGFloat = 60

    private var cardVisible = false
    private var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    private var runningAnimations = [UIViewPropertyAnimator]() // will store all animations
    private var animationProgressWhenInterrupted: CGFloat = 0
    
    init?(coder: NSCoder, location: RecycleLocation) {
        self.location = location
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        configureMapView()
        loadMapAnnotations()
        setUpChildView()
    }
    
    private func configureMapView() {
        mapView.delegate = self
    }
    
    private func setupUI() {
        boarderView.addShadowToView(cornerRadius: AppViews.cornerRadius)
    }
    
    private func loadMapAnnotations() {
        let annotation = MKPointAnnotation()
        annotation.title = location.name
        
        if let coordinates = location.location {
            latitude = coordinates.latitude
            longitude = coordinates.longitude
        }
        
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let placeCoordinate = CLLocationCoordinate2DMake(Double(latitude), Double(longitude))
        annotation.coordinate = placeCoordinate
        mapView.addAnnotation(annotation)
        DispatchQueue.main.async {
            self.mapView.showAnnotations([annotation], animated: true)
        }
    }
    
    private func dialNumber(number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url) // deprecated in iOS 10
            }
        } else {
            showAlert(title: "Error", message: "Unable to dial phone number")
        }
    }
    
    private func getAddress() -> String {
        guard let zipcode = location.zipcode else {
            return ""
        }
        return "\(location.fullAddress) \(zipcode)"
    }
    
    private func updateUI() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = location.name
        hoursLabel.text = location.hours
        phoneNumberButton.setTitle(location.phoneNumber, for: .normal)
        addressLabel.text = getAddress()
    }
    
    @IBAction func phoneNumberPressed(_ sender: UIButton) {
        // call number
        let set = CharacterSet(charactersIn: "+*#0123456789")
        let phoneNum = location.phoneNumber.components(separatedBy: set.inverted).joined()
        dialNumber(number: phoneNum)
    }
    
    @IBAction func websitePressed(_ sender: UIButton) {
        // go to website
        guard let url = URL(string: location.website ?? "") else {
            showAlert(title: "Error", message: "Website unavailable.")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    @IBAction func drivingButtonPressed(_ sender: UIButton) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let placeCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        openMapsAppWithDirections(to: placeCoordinate, destinationName: location.name, mode: MKLaunchOptionsDirectionsModeDriving)
    }
    
    @IBAction func walkingButtonPressed(_ sender: UIButton) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let placeCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        openMapsAppWithDirections(to: placeCoordinate, destinationName: location.name, mode: MKLaunchOptionsDirectionsModeWalking)
    }
    
    @IBAction func transitButtonPressed(_ sender: UIButton) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let placeCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        openMapsAppWithDirections(to: placeCoordinate, destinationName: location.name, mode: MKLaunchOptionsDirectionsModeTransit)
    }
}

extension LocationDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {return nil}
        let identifier = "annotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = AppColors.darkGreen
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String, mode: String) {
        let options = [MKLaunchOptionsDirectionsModeKey: mode]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name // Provide the name of the destination in the To: field
        mapItem.openInMaps(launchOptions: options)
    }
}

// set child view controller
extension LocationDetailViewController {
    
    func setUpChildView() {
        cardHeight = self.view.frame.height * 0.8
        
        visualEffectView = UIVisualEffectView() // initailizing
        visualEffectView.frame = self.view.frame // make it same size as view
        self.view.addSubview(visualEffectView) // add blur
        visualEffectView.isUserInteractionEnabled = false 
        
        childViewController = AcceptedItemsController(nibName: "AcceptedItemsController", bundle: nil) // intializing
        childViewController.location = location // pass location
        
        self.addChild(childViewController)
        self.view.addSubview(childViewController.view) //add child view
    
        // set frame of card view controller view
       
        childViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight - (self.tabBarController?.tabBar.frame.height ?? 0), width: self.view.bounds.width, height: cardHeight)
        childViewController.view.clipsToBounds = true // important for corner radius
                
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LocationDetailViewController.handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(LocationDetailViewController.handleCardPan(recognizer:)))
        // add tap and pan gestures to the handle view of the card view
        
        childViewController.handleView.addGestureRecognizer(tapGestureRecognizer)
        childViewController.handleView.addGestureRecognizer(panGestureRecognizer)
        childViewController.view.addShadowToView(color: .darkGray, cornerRadius: AppViews.cornerRadius)
    }
    
    @objc
    private func handleCardTap(recognizer: UITapGestureRecognizer) {
        // when tapped should display it completely
        animateTransitionIfNeeded(state: nextState, duration: 0.9)
    }
    
    @objc
    private func handleCardPan(recognizer: UIPanGestureRecognizer) {
        // a pan gesture regonizer has multiple states
        // were interested in - begin, changed, ended states
        // we will handle the states using a switch statement
        
        switch recognizer.state {
        case .began:
            // start transition
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            // change translation of our recognizer - cordinates
            let translation = recognizer.translation(in: self.childViewController.handleView)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            
            // update transition
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            // continue transition
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        // check if animations is empty
        if runningAnimations.isEmpty {
            // add frame animator
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                // define what is happening then move card up or down
                switch state {
                case .expanded:
                    //expand card
                    self.childViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    // collapse card
                    self.childViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - (self.tabBarController?.tabBar.frame.height ?? 0)
                }
            }
            
            // when animation is complete
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll() // we no longer need any of the animators
            }
            frameAnimator.startAnimation()  // start animations
            runningAnimations.append(frameAnimator)
        }
        
        let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.visualEffectView.effect = UIBlurEffect(style: .prominent)
            case .collapsed:
                self.visualEffectView.effect = nil
            }
        }
        blurAnimator.startAnimation()
        runningAnimations.append(blurAnimator)
    }

    private func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        // check if we do have running animations
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        // in order to make all this interactive
        // we might have multiple animators
        for animator in runningAnimations {
            animator.pauseAnimation() // set speed to 0
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }

    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }

    private func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
