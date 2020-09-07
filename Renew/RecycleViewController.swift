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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchButton.backgroundColor = #colorLiteral(red: 0.08992762119, green: 0.6527115107, blue: 0.6699190736, alpha: 1)
        searchButton.layer.cornerRadius = 5
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = #colorLiteral(red: 0.7058743834, green: 0.8751116395, blue: 0.8098524213, alpha: 1)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
    // display view controller with list of places
        // call db function to retrieve locations
        // use indicator view to indicate search
        // if 0 items: found display an alert controller telling them no items were found
        // else: pass the array of locations to the next vc using dependency injection and display VC
        
        let locationsVC = LocationsViewController([])
//        locationsVC.modalPresentationStyle = .fullScreen
//        present(locationsVC, animated: true)
        
        navigationController?.pushViewController(locationsVC, animated: true)
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
