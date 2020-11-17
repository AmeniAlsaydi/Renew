//
//  User.swift
//  Renew
//
//  Created by Amy Alsaydi on 8/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

// At some point i might want to add display name to make it a more personal experience
// Also for the msging aspect of it

struct User {
    let createdDate: Date
    let email: String
    let firstTimeLogin: Bool
    let id: String
    
    var dict: [String: Any] {
        ["createdDate": createdDate,
         "email": email,
         "firstTimeLogin": firstTimeLogin,
         "id": id]
    }
}
extension User {
    init(_ dictionary: [String: Any]) {
        self.createdDate = dictionary["createdDate"] as? Date ?? Date()
        self.email = dictionary["email"] as? String ?? "No email"
        self.firstTimeLogin = dictionary["firstTimeLogin"] as? Bool ?? true
        self.id = dictionary["id"] as? String ?? "No ID available"
    }
}
