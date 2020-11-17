//
//  RecycleViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseFirestore

class RecycleViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    private var location: GeoPoint? {
        didSet {
            getLocations()
        }
    }
    
    lazy var textFields: [UITextField] = [itemNameTextField, zipcodeTextField]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        _ = textFields.map {
            $0.backgroundColor = AppColors.white
            $0.addShadowToView(cornerRadius: 3, opacity: 0.2)
        }
        searchButton.addShadowToView(cornerRadius: 10)
        
        if Auth.auth().currentUser == nil {
            signOutButton.isEnabled = false
        }
    }
    
    /// This function should take in all locations returned from the database, current lat and long (whether is from current location or the zipcode they enter ~ for now its zipcode) and a miles value (defaults to 5 miles)
    /// and return the filtered locations in that mile radius
    private func filterLocationsByMiles(locations: [RecycleLocation], location: GeoPoint?, miles: Double = 5) -> [RecycleLocation] {
        
        guard let location = location else {
            return []
        }
        // TODO: confirm this
        // ~1 mile of lat and lon in degrees
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = location.latitude - (lat * miles)
        let lowerLon = location.longitude - (lon * miles)
        
        let upperLat = location.latitude + (lat * miles)
        let upperLon = location.longitude + (lon * miles)
        
        let filteredLocations = locations.filter { (location) -> Bool in
            guard let geopoint = location.location else { return false }
            
            if geopoint.latitude > lowerLat && geopoint.latitude < upperLat && geopoint.longitude > lowerLon && geopoint.longitude < upperLon {
                 return true
            } else {
                return false
            }
        }
        
        return filteredLocations
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        guard let itemName = itemNameTextField.text, !itemName.isEmpty, let zipcode = zipcodeTextField.text else {
            
            showAlert(title: "Missing fields", message: "Please provide both the item name and a zipcode.")
            return
        }
        
        //get lat & long from zipcode:
        getCoordinateFrom(address: zipcode) { [weak self] (coordinate, error)  in
            guard let coordinate = coordinate, error == nil else { return }
            
            self?.location = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        
        showOptionsAlert(title: nil, message: "Are you sure you want to sign out?", option1: "Yes", option2: "No") { (action) in
            if action.title == "Yes" {
                do {
                    try Auth.auth().signOut()
                    UIViewController.showViewController(storyBoardName: "LoginView", viewControllerId: "LoginViewController")
                } catch {
                    self.showAlert(title: "Error signing out", message: "\(error.localizedDescription)")
                }
            }
        }
    }
    
    private func getLocations() {
        guard let itemName = itemNameTextField.text, let location = location else { return }
        
        DatabaseService.shared.getLocationsThatAcceptItem(itemName: itemName) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error getting locations", message: "\(error)")
            case .success(let locations):
                // let count = locations.count
                let filteredLocations = self?.filterLocationsByMiles(locations: locations, location: location)
                
                if !filteredLocations!.isEmpty {
                    let locationsVC = LocationsViewController(filteredLocations!)
                    self?.navigationController?.pushViewController(locationsVC, animated: true)
                } else {
                    self?.showAlert(title: "No locations found", message: "Check input")
                }
            }
        }
        
        //TODO: Fix this.
        /*
         This is how the current filter works - no good
         - Get the lat and long of the entered zipcode
            to test: 11201 lat: 40.695, long: -73.989
         - Get all the locations
         - Call the filterLocationsByMiles using the above parameters
         - and call then present locationsVC with the filteredLocations returned from above function call ^
         */
    }
    private func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> Void) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
        // CLPlacemarks return array can be multiple if entry is too vague
        // we choose first and return its coordinate info
        // CLPlacemark.CLLocation.CLLocationCoordinate2D
        // location property of place mark is of type CLLocation
        // coordinate propterty of CLLocation is of type CLLocationCoordinate2D
        // CLLocationCoordinate2D: is what our completion handler accepts 
    }
}
