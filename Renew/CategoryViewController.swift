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
    
    @IBAction func savedButtonClicked(_ sender: UIBarButtonItem) {
        
        if let _ = Auth.auth().currentUser {
            let storyboard = UIStoryboard(name: "MainView", bundle: nil)
            guard let savedVC = storyboard.instantiateViewController(identifier: "SavedViewController") as? SavedViewController else {
                fatalError("couldnt get itemsVC")
            }
            
            navigationController?.pushViewController(savedVC, animated: true)
        } else {
            showAlert(title: "Not a user", message: "you should sign up so you can save and easily access them easily.")
        }
        
        
        
    }
    
}


extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCell else {
            fatalError("could not downcast to category cell")
        }
        let category = categories[indexPath.row]
        cell.configureCell(category: category)
        cell.backgroundColor = #colorLiteral(red: 0.7058743834, green: 0.8751116395, blue: 0.8098524213, alpha: 1)
        return cell
        
    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // make height 1/5 of safe area screen
        // make width full screen width
        
        let maxSize = UIScreen.main.bounds
        
        let height = maxSize.height * 0.15
        let width = maxSize.width  * 0.95
        
        return CGSize(width: width, height: height)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // push item view controller
        // storybaord id: ItemsViewController
        
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        guard let itemsVC = storyboard.instantiateViewController(identifier: "ItemsViewController") as? ItemsViewController else {
            fatalError("couldnt get itemsVC")
        }
        
        itemsVC.category = categories[indexPath.row] // use dependency injection instead
        
        navigationController?.pushViewController(itemsVC, animated: true)
        
    }
}
