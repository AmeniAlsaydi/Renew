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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    var items = [Item]() {
        didSet {
            //dump(items)
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getItems()
        navigationItem.title = category?.materialType
        
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
                self?.items = items // filter this based on the current material type id
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
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.itemName
        
        return cell
    }
}

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") {
            (coder) in
            return DetailViewController(coder: coder, item: item)
            
        }
        present(detailVC, animated: true)
        //navigationController?.pushViewController(detailVC, animated: true)
    }
}
 


