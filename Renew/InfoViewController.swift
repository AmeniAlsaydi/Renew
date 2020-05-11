//
//  InfoViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

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

}


extension InfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCell else {
            fatalError("could not downcast to category cell")
        }
        let category = categories[indexPath.row]
        cell.configureCell(category: category)
        cell.backgroundColor = #colorLiteral(red: 0.6414951086, green: 0.6908316016, blue: 0.85561198, alpha: 1)
        return cell
        
    }
}

extension InfoViewController: UICollectionViewDelegateFlowLayout {
    
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
}
