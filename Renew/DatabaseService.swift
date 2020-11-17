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
    static let savedCollection = "savedItems"
    static let locations = "recycleLocations"
    static let acceptedItems = "acceptedItems"
    
    private let db = Firestore.firestore()
    
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>) -> Void) {
           guard let email = authDataResult.user.email else {
               return
           }
           db.collection(DatabaseService.userCollection).document(authDataResult.user.uid).setData(["email": email, "createdDate": Timestamp(date: Date()), "id": authDataResult.user.uid, "firstTimeLogin": true]) { error in
               if let error = error {
                   completion(.failure(error))
               } else {
                   completion(.success(true))
               }
           }
       }
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        db.collection(DatabaseService.categoriesCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let categories = snapshot.documents.map { Category($0.data())}
                completion(.success(categories))
            }
        }
    }

    public func getItems(completion: @escaping (Result<[Item], Error>) -> Void) {
        db.collection(DatabaseService.itemsCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let items = snapshot.documents.map { Item($0.data())}
                completion(.success(items))
            }
        }
    }
    
    public func addItemToSaved(item: Item, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.savedCollection).document(item.id).setData(item.dict) {(error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func isItemSaved(item: Item, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.savedCollection).whereField("id", isEqualTo: item.id).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                if !snapshot.documents.isEmpty {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    
    public func deleteItemFromSaved(item: Item, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.savedCollection).document(item.id).delete { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func getSavedItems(completion: @escaping (Result<[Item], Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.savedCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let items = snapshot.documents.map { Item($0.data())}
                completion(.success(items))
            }
        }
    }
    
    public func getLocationsThatAcceptItem(itemName: String, completion: @escaping (Result<[RecycleLocation], Error>) -> Void) {
        // TODO: string literal bad 
        db.collection(DatabaseService.locations).whereField("acceptedItems", arrayContains: itemName.capitalized).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let locations = snapshot.documents.map { RecycleLocation($0.data())}
                completion(.success(locations))
            }
        }
    }
    
    public func getAcceptedItems(for locationId: String, completion: @escaping (Result<[AcceptedItem], Error>) -> Void) {
        db.collection(DatabaseService.locations).document(locationId).collection(DatabaseService.acceptedItems).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let items = snapshot.documents.map { AcceptedItem($0.data())}
                completion(.success(items))
            }
        }
    }
}
