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
    @IBOutlet weak var acceptedItemsLabel: UILabel!
    
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
        handleView.layer.cornerRadius = AppViews.cornerRadius
        handleView.backgroundColor = .tertiarySystemGroupedBackground
        view.alpha = 0.85
        acceptedItemsLabel.font = AppFonts.headline.bold()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AcceptedItemCell", bundle: nil), forCellWithReuseIdentifier: "acceptedItemCell")
        
        if let flowLayout = flowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
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
        let itemWidth: CGFloat =  maxsize.width - (2 * AppViews.cellPadding)
        let itemHeight: CGFloat = maxsize.height * AppViews.smallCellHeightRatio
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: AppViews.cellPadding, left: AppViews.cellPadding, bottom: AppViews.cellPadding, right: AppViews.cellPadding)
    }
}
