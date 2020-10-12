//
//  DetailViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Kingfisher

/*
 - add a "learn more" button beneath the 4 bottom labels
 - the lables should load as empty strings
 - if the "learn more" button is pressed the labels should be filled with the correct content in an animation
 - then convert the "learn more" -> "less"
 */

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var whyRecycleLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var whyRecycleTitleLabel: UILabel!
    @IBOutlet weak var processTitleLabel: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    
    private var item: Item
    
    var isSaved: Bool = false {
        didSet {
            if isSaved {
                saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }
    
    init?(coder: NSCoder, item: Item) {
        self.item = item
        super.init(coder:coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = UIColor.systemGroupedBackground
        configureCollectionView()
        updateUI()
        isItemSaved()
    }
    
    private func getSteps() -> String {
        var steps = ""
        /// Im thinking of having this part as a collection view they can swipe to see following steps instead of it just presented as a list.
        for i in 1...item.prepSteps.count {
            steps += "\(i). \(item.prepSteps[i - 1]) \n"
        }
        
        return steps
    }
    
    private func getReasons() -> String {
        var reasons = ""
        
        for i in 0..<item.whyRecycle.count {
            reasons += "• \(item.whyRecycle[i]) \n"
        }
        
        return reasons
        
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func updateUI() {
        
        itemNameLabel.text = item.itemName
        descriptionLabel.text = item.description
        itemImage.kf.setImage(with: URL(string: item.imageURL))
        
        whyRecycleLabel.text = ""
        processLabel.text = ""
        whyRecycleTitleLabel.text = ""
        processTitleLabel.text = ""
        
        whyRecycleLabel.alpha = 0
        processLabel.alpha = 0
        whyRecycleTitleLabel.alpha = 0
        processTitleLabel.alpha = 0
        
    }
    
    private func isItemSaved() {
        DatabaseService.shared.isItemSaved(item: item) { (result) in
            switch result {
            case .failure(let error):
                print("\(error.localizedDescription)")
            case .success(let isSaved):
                self.isSaved = isSaved
            }
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if isSaved {
            DatabaseService.shared.deleteItemFromSaved(item: item) { [weak self] (result) in
                switch result {
                case.failure(let error):
                    self?.showAlert(title: "Error removing item from saved", message: "\(error.localizedDescription)")
                case .success:
                    self?.isSaved = false
                }
            }
        } else {
            DatabaseService.shared.addItemToSaved(item: item) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    self?.showAlert(title: "Error adding item to saved", message: "\(error.localizedDescription)")
                case .success(let isSaved):
                    self?.isSaved = isSaved
                }
            }
        }
    }
    
    
    @IBAction func learnButtonPressed(_ sender: UIButton) {
        
        learnMoreButton.isHidden = true
        
        self.whyRecycleTitleLabel.text = "Why Recycle"
        self.processTitleLabel.text = "Recycling Process"
        self.whyRecycleLabel.text = self.getReasons()
        self.processLabel.text = self.item.recylcingProcess
        
        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded()
        }
        
        /// the combined height of the 4 labels
        /// should they all just be in a stack and use stack height?
        let combinedHeight = whyRecycleTitleLabel.frame.height + processTitleLabel.frame.height + whyRecycleLabel.frame.height + processLabel.frame.height //+ 60
        
        UIView.animate(withDuration: 1.5, delay: 0.2, options: [.transitionCrossDissolve]) {
            
            self.scrollView.contentOffset.y += combinedHeight
            self.whyRecycleLabel.alpha = 1
            self.processLabel.alpha = 1
            self.whyRecycleTitleLabel.alpha = 1
            self.processTitleLabel.alpha = 1
           
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.prepSteps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stepsCell", for: indexPath) as? StepsCell else {
            fatalError("could not downcast to a steps cell")
        }
        let step = item.prepSteps[indexPath.row]
        let stepNum = indexPath.row + 1
        let isLast = stepNum ==  item.prepSteps.count
        
        cell.configureCell(stepNum: stepNum, step: step, isLast: isLast)
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize = collectionView.frame.size
        
        let height = maxSize.height * 0.95
        let width = height * 0.65

        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}
