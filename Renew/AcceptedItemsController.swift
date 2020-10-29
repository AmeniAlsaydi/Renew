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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var handle: UIView!
    
    public var location: RecycleLocation?
    
    private var acceptedItems = [AcceptedItem]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        getAcceptedItem()
        configureHandleView()
    }
    
    private func configureHandleView() {
        handle.layer.cornerRadius = 3
        handleView.layer.cornerRadius = AppRoundedViews.cornerRadius
        handleView.backgroundColor = .tertiarySystemGroupedBackground
        view.alpha = 0.8
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        // register cell
        collectionView.register(UINib(nibName: "AcceptedItemCell", bundle: nil), forCellWithReuseIdentifier: "acceptedItemCell")
        
        if let flowLayout = flowLayout,
                   let collectionView = collectionView {
                   let w = collectionView.frame.width - 20
                   flowLayout.estimatedItemSize = CGSize(width: w, height: 200)
        }
    }
    
    private func getAcceptedItem() {
        
        guard let location = location else {
            print("no location passed from parent view")
            return
        }
        DatabaseService.shared.getAcceptedItems(for: location.id) { [weak self] (result) in
            switch result {
            case(.failure(let error)):
                print("error getting items found \(error)")
            case(.success(let items)):
                self?.acceptedItems = items
            }
        }
    }
}

extension AcceptedItemsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return acceptedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "acceptedItemCell", for: indexPath) as? AcceptedItemCell else {
            fatalError("could not dequeue to accetpedItemCell")
        }
        let item = acceptedItems[indexPath.row]
        cell.configureCell(item)
        return cell
    }
}

extension AcceptedItemsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize = UIScreen.main.bounds
        let itemWidth: CGFloat =  maxsize.width * 0.95
        let itemHeight: CGFloat = maxsize.height * 0.1
        // TODO: make this self sizing
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
