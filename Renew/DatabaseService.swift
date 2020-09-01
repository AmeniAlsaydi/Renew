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
    
    private let db = Firestore.firestore()
    
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>)-> ()) {
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
    
    // TODO: Save items, deleted from saved
    
    public func addItemToSaved(item: Item, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.savedCollection).document(item.id).setData(["id": item.id, "description": item.description, "imageURL": item.imageURL, "itemName": item.itemName, "materialID": item.materialID, "recylcingProcess": item.recylcingProcess, "prepSteps": item.prepSteps, "whyRecycle": item.whyRecycle]){ (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func isItemSaved(item: Item, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.savedCollection).whereField("id", isEqualTo: item.id).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                if snapshot.documents.count > 0 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    
    public func deleteItemFromSaved(item: Item, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.savedCollection).document(item.id).delete { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func getSavedItems(completion: @escaping (Result<[Item], Error>) -> ()) {
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
    
    // get locations based on zipcode & item input
    
    public func getLocations(zipcode: Int, completion: @escaping (Result<[RecycleLocation], Error>) -> ()) {
        
        db.collection(DatabaseService.locations).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let locations = snapshot.documents.map { RecycleLocation($0.data())}.filter{ $0.zipcode == zipcode}
                completion(.success(locations))
            }
        }
    }
}
