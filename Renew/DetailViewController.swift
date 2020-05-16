//
//  DetailViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    private var item: Item
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var whyRecycleLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
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

    }
    
    private func getSteps() -> String {
        var steps = ""
        // Im thinking of having this part as a collection view they can swipe to see following steps instead of it just presented as a list.
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
        // collectionView.backgroundColor = UIColor.systemGroupedBackground
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func updateUI() {
        
        itemNameLabel.text = item.itemName
        descriptionLabel.text = item.description
        //prepLabel.text = getSteps()
        whyRecycleLabel.text = getReasons()
        processLabel.text = item.recylcingProcess
        itemImage.kf.setImage(with: URL(string: item.imageURL))
    }
    

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
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
        let maxSize = UIScreen.main.bounds
        
        let width = maxSize.width * 0.95
        let height = width * 0.70
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
