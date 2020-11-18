//
//  InfoViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var subTitleLabel: UILabel!

    var categories = [Category]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        getCategories()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func getCategories() {
        DatabaseService.shared.getCategories { [weak self] (results) in
            switch results {
            case(.failure(let error)):
                print("error getting categories: \(error.localizedDescription)")
            case(.success(let categories)):
                self?.categories = categories
            }
        }
    }
    
    private func presentSavedItems() {
        
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "MainView", bundle: nil)
            guard let savedVC = storyboard.instantiateViewController(identifier: SavedViewController.identifier) as? SavedViewController else {
                fatalError("couldnt get itemsVC")
            }
            
            navigationController?.pushViewController(savedVC, animated: true)
        } else {
            
            let storyboard = UIStoryboard(name: "MainView", bundle: nil)
            
            guard let guestPromptVC = storyboard.instantiateViewController(identifier: GuestPromptViewController.identifier) as? GuestPromptViewController else {
                fatalError("couldnt get promptVC")
            }
            
            present(guestPromptVC, animated: true)
        }
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.resuseId, for: indexPath) as? CategoryCell else {
            fatalError("could not downcast to category cell")
        }
        if indexPath.row == 0 {
            cell.categoryLabel.text = "My Favorites"
            cell.categoryImage.image = UIImage(named: "bookmark")
        } else {
            let category = categories[indexPath.row - 1]
            cell.configureCell(category: category)
        }
        return cell
    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize = UIScreen.main.bounds
        let height = maxSize.height * AppViews.largeCellHeightRatio
        let width = maxSize.width - (2 * AppViews.cellPadding)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: AppViews.cellPadding, left: AppViews.cellPadding, bottom: AppViews.cellPadding, right: AppViews.cellPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        guard let itemsVC = storyboard.instantiateViewController(identifier: "ItemsViewController") as? ItemsViewController else {
            fatalError("couldnt get itemsVC")
        }
        if indexPath.row == 0 {
            presentSavedItems()
        } else {
            itemsVC.category = categories[indexPath.row - 1] // use dependency injection instead
            navigationController?.pushViewController(itemsVC, animated: true)
        }
    }
}
