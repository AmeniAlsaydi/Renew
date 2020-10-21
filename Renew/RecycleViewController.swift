//
//  RecycleViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

class RecycleViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    lazy var textFields: [UITextField] = [itemNameTextField, zipcodeTextField]
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        _ = textFields.map { $0.addShadowToTextField(cornerRadius: 3)}
        searchButton.layer.cornerRadius = 5
    }
    
    /// This function should take in all locations returned from the database, current lat and long (whether is from current location or the zipcode they enter ~ for now its zipcode) and a miles value (defaults to 5 miles)
    /// and return the filtered locations in that mile radius
    private func filterLocationsByMiles(locations: [RecycleLocation], latitude: Double, longitude: Double, miles: Double = 5) -> [RecycleLocation] {
        
        // TODO: confirm this
        // ~1 mile of lat and lon in degrees
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = latitude - (lat * miles)
        let lowerLon = longitude - (lon * miles)
        
        let upperLat = latitude + (lat * miles)
        let upperLon = longitude + (lon * miles)
        
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
        
        guard let itemName = itemNameTextField.text, !itemName.isEmpty, let zipcode = zipcodeTextField.text, let zipcodeAsInt = Int(zipcode) else {
            
            showAlert(title: "Missing fields", message: "Please provide both the item name and a zipcode.")
            return
        }
        
    // display view controller with list of places
        // call db function to retrieve locations ✅
        // use indicator view to indicate search
        // if 0 items: found display an alert controller telling them no items were found
        // else: pass the array of locations to the next vc using dependency injection and display VC
       
        DatabaseService.shared.getLocationsThatAcceptItem(zipcode: zipcodeAsInt, itemName: itemName) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error getting locations", message: "\(error)")
            case .success(let locations):
                // let count = locations.count
                if !locations.isEmpty { //count > 0 -> swiftlint doesnt like this
                    let locationsVC = LocationsViewController(locations)
                    self?.navigationController?.pushViewController(locationsVC, animated: true)
                } else {
                    self?.showAlert(title: "No locations found", message: "Check input")
                }
            }
        }
        
        //TODO: here is where the new filter will be tested
        /*
         Things I need to do:
         - Get the lat and long of the entered zipcode
         - Get all the locations
         - Call the filterLocationsByMiles using the above parameters
         - and call then present locationsVC with the filteredLocations returned from above function call ^
         */
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
    
}
