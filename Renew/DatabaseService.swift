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
    
    
}
