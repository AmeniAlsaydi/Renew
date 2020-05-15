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
    
    init?(coder: NSCoder, item: Item) {
        self.item = item
        super.init(coder:coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        for i in 0..<item.whyRecyle.count {
            reasons += "• \(item.whyRecyle[i]) \n"
        }
        
        return reasons
        
    }
    
    private func updateUI() {
        
        itemNameLabel.text = item.itemName
        descriptionLabel.text = item.description
        prepLabel.text = getSteps()
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
