//
//  AcceptedItemsController.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class AcceptedItemsController: UIViewController {
    
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .blue
    }

    
}
