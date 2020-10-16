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
    
    private var savedItems = [Item]() {
        didSet {
            DispatchQueue.main.async {
                if self.savedItems.isEmpty {
                    self.savedView.collectionView.backgroundView = EmptyView(title: "No Items Saved Yet", message: "Save items and have easy access to them here. Click on bookmark to save. Happy Recycling! 🌍", imageName: "recycleHouse")
                } else {
                    self.savedView.collectionView.backgroundView = nil
                }
                self.savedView.collectionView.reloadData()
            }
        }
    }
    
    override func loadView() {
        view = savedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Saved Recyclables"
        configureCollectionView()
        getSavedItems()
    }
    
    private func getSavedItems() {
        DatabaseService.shared.getSavedItems { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("could not load saved items \(error.localizedDescription)") // this should be an alert controller with a try again button that reloads the collection view 
            case .success(let items):
                self?.savedItems = items
            }
        }
    }
    
    private func configureCollectionView() {
        savedView.collectionView.delegate = self
        savedView.collectionView.dataSource = self
        savedView.collectionView.register(UINib(nibName: "SavedCell", bundle: nil), forCellWithReuseIdentifier: "savedCell")
    }
}

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxSize = UIScreen.main.bounds
        
        let height = maxSize.height * 0.11
        let width = maxSize.width * 0.95
        
        return CGSize(width: width, height: height)
    }

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
             return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
         }
}

extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedCell", for: indexPath) as? SavedCell else {
            fatalError("could not dequeue cell to saved cell")
        }
        let item = savedItems[indexPath.row]
        cell.configureCell(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = savedItems[indexPath.row]
        
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") { (coder) in
            return DetailViewController(coder: coder, item: item)
            
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
