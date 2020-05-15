//
//  ItemsViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/14/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    var items = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

        getItems()
        
        // Do any additional setup after loading the view.
    }
    
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getItems() {
        DatabaseService.shared.getItems { [weak self] (results) in
            switch results {
            case(.failure(let error)):
                print("error getting items: \(error.localizedDescription)")
            case(.success(let items)):
                self?.items = items
            }
        }
    }
}

extension ItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = "Amal"
        
        return cell
    }
}

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
 
