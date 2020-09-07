//
//  RecycleViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class RecycleViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchButton.backgroundColor = #colorLiteral(red: 0.08992762119, green: 0.6527115107, blue: 0.6699190736, alpha: 1)
        searchButton.layer.cornerRadius = 5
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = #colorLiteral(red: 0.7058743834, green: 0.8751116395, blue: 0.8098524213, alpha: 1)
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
                let count = locations.count
                print("locations returned \(count)")
                if count > 0 {
                    let locationsVC = LocationsViewController(locations)
                    self?.navigationController?.pushViewController(locationsVC, animated: true)
                } else {
                    self?.showAlert(title: "No locations found", message: "Check input")
                }
            }
        }
        
        
        
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
