//
//  ItemsViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/14/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    
    var category: Category?
        
    public lazy var collectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .vertical
           let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
           cv.backgroundColor = .systemGroupedBackground
           return cv
       }()

    private var searchController: UISearchController!
    
    var items = [Item]()
    
    var filteredItems = [Item]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var searchText = "" {
        didSet {
            filteredItems = items.filter { $0.itemName.lowercased().contains(searchText) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getItems()
        configureSearchController()
        configureCollectionView()
        navigationItem.title = category?.materialType
    }
    
    private func configureCollectionView() {
        collectionViewConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SavedCell", bundle: nil), forCellWithReuseIdentifier: SavedCell.reuseId)
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self // think of this like a delegate
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func getItems() {
        DatabaseService.shared.getItems { [weak self] (results) in
            switch results {
            case(.failure(let error)):
                print("error getting items: \(error.localizedDescription)")
            case(.success(let items)):
                self?.items = items.filter { $0.materialID == self?.category?.id} // filter this based on the current material type id
                self?.filteredItems = items.filter { $0.materialID == self?.category?.id}
            }
        }
    }
    
    private func collectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}
 
extension ItemsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // this gets called every time something is typed
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            getItems()
            return
        }
        searchText = text
    }
    
}

extension ItemsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize = UIScreen.main.bounds
        let height = maxSize.height * AppViews.smallCellHeightRatio
        let width = maxSize.width - (2 * AppViews.cellPadding)
        
        return CGSize(width: width, height: height)
    }

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
             return UIEdgeInsets(top: AppViews.cellPadding, left: AppViews.cellPadding, bottom: AppViews.cellPadding, right: AppViews.cellPadding)
         }
}

extension ItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedCell.reuseId, for: indexPath) as? SavedCell else {
            fatalError("could not dequeue cell to saved cell")
        }
        let item = filteredItems[indexPath.row]
        cell.configureCell(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = filteredItems[indexPath.row]
        
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: DetailViewController.identifier) { (coder) in
            return DetailViewController(coder: coder, item: item)
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
