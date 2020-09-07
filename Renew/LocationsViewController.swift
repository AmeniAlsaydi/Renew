//
//  LocationsViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController {
    
    private let locationView = LocationsView()
    private var locations: [RecycleLocation]
    
    // initializer
    
    init(_ locations: [RecycleLocation]) {
        self.locations = locations
        super.init(nibName: nil, bundle: nil) // ?? 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = locationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Do any additional setup after loading the view.
    }
    

    

}
