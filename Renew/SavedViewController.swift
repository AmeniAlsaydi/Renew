//
//  SavedViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {
    
    private var savedView = SavedView()
    
    override func loadView() {
        view = savedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Saved Recyclables"
        configureCollectionView()

        // Do any additional setup after loading the view.
    }
    
    private func configureCollectionView() {
        savedView.collectionView.backgroundView = EmptyView(title: "No Items Saved Yet", message: "Save items and have easy access to them here. Click on bookmark to save. Happy Recycling!", imageName: "recycleHouse")
        savedView.collectionView.delegate = self
        savedView.collectionView.dataSource = self
        // savedView.collectionView.register(SavedCell.self, forCellWithReuseIdentifier: "savedCell")
        
    }
    
    
    

}

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    
}

extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "saveCell", for: indexPath)
        return cell
    }
    
    
}

