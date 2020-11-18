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
        navigationItem.largeTitleDisplayMode = .never
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        locationView.collectionView.delegate = self
        locationView.collectionView.dataSource = self
        locationView.collectionView.register(UINib(nibName: "LocationCell", bundle: nil), forCellWithReuseIdentifier: LocationCell.reuseId)
    }
}

extension LocationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCell.reuseId, for: indexPath) as? LocationCell else {
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
        let itemWidth: CGFloat = maxsize.width - (2 * AppViews.cellPadding)
        let itemHeight: CGFloat = maxsize.height * AppViews.smallCellHeightRatio
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: AppViews.cellPadding, left: AppViews.cellPadding, bottom: AppViews.cellPadding, right: AppViews.cellPadding)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: LocationDetailViewController.identifier) { (coder) in
            return LocationDetailViewController(coder: coder, location: location)
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
