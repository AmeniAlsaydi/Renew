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
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        locationView.collectionView.delegate = self
        locationView.collectionView.dataSource = self
        locationView.collectionView.register(UINib(nibName: "LocationCell", bundle: nil), forCellWithReuseIdentifier: "locationCell")
    }
}

extension LocationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as? LocationCell else {
            fatalError("could not dequeue to LocationCell")
        }
        let location = locations[indexPath.row]
        cell.configureCell(location)
        return cell
    }
}

extension LocationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize: CGSize = view.frame.size
        let itemWidth: CGFloat = maxsize.width * 0.95
        let itemHeight: CGFloat = maxsize.height * 0.1
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
