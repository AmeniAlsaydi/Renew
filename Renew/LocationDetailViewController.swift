//
//  LocationDetailViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailViewController: UIViewController {
    
    @IBOutlet weak var boarderView: UIView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let location: RecycleLocation
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    init?(coder: NSCoder, location: RecycleLocation) {
        self.location = location
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        boarderView.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureMapView()
        loadMapAnnotations()
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
    }
    
    private func loadMapAnnotations()  {
        
        let annotation = MKPointAnnotation()
        annotation.title = location.name
        getCoordinateFrom(address: getAddress()) { [weak self] (coordinate, error) in
            guard let coordinate = coordinate, error == nil else { return }
            
            self?.latitude = coordinate.latitude
            self?.longitude = coordinate.longitude
            
            let placeCoordinate = CLLocationCoordinate2DMake(Double(coordinate.latitude), Double(coordinate.longitude))
            annotation.coordinate = placeCoordinate
            self?.mapView.addAnnotation(annotation)
            DispatchQueue.main.async {
                //                     self?.removeIndicator()
                self?.mapView.showAnnotations([annotation], animated: true)
            }
        }
    }
    
    private func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
            print("error dialing number ")
       }
    }
    
    @IBAction func phoneNumberPressed(_ sender: UIButton) {
        // call number
        let set = CharacterSet(charactersIn: "+*#0123456789")
        let phoneNum = location.phoneNumber.components(separatedBy: set.inverted).joined()
        dialNumber(number: phoneNum)
    }
    
    @IBAction func websitePressed(_ sender: UIButton) {
        // go to websitr
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

    private func getAddress() -> String {
        guard let zipcode = location.zipcode else {
            return ""
        }
        let address = location.address ?? ""
        let city = location.city ?? ""
        let state = location.state ?? ""
        
        let fullAddress = "\(address) \(city) \(state) \(zipcode)"
        return fullAddress
    }
    
    private func updateUI() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = location.name
        hoursLabel.text = location.hours
        phoneNumberButton.setTitle(location.phoneNumber, for: .normal)
        addressLabel.text = getAddress()
    }
}

extension LocationDetailViewController: MKMapViewDelegate {
    
    private func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {return nil}
        let identifier = "annotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = #colorLiteral(red: 0.08992762119, green: 0.6527115107, blue: 0.6699190736, alpha: 1)
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
