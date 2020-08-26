//
//  DatabaseService.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class DatabaseService {
    public static let shared = DatabaseService()
    private init() {}
    
    static let userCollection = "users"
    static let categoriesCollection = "materialCategories"
    static let itemsCollection = "recyclableItems"
    
    private let db = Firestore.firestore()
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> ()) {
        
        db.collection(DatabaseService.categoriesCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let categories = snapshot.documents.map { Category($0.data())}
                completion(.success(categories))
            }
        }
    }
    
    // get items array
    public func getItems(completion: @escaping (Result<[Item], Error>) -> ()) {
        db.collection(DatabaseService.itemsCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let items = snapshot.documents.map { Item($0.data())}
                completion(.success(items))
            }
        }
        
    }
    
    // filter this return by the category name ($0.material type == plastic) ????
    
    
}
