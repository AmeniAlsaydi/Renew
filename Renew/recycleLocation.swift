//
//  recycleLocation.swift
//  Renew
//
//  Created by Amy Alsaydi on 8/28/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct RecycleLocation {
    var id: String
    var name: String
    var website: String?
    var address: String?
    var city: String?
    var state: String?
    var zipcode: Int?
    var phoneNumber: String
    var hours: String
    var notes: String? // MAYBE
    var acceptedItems: [String]
    // there will also be a sub collection of accpetedItems 
}

extension RecycleLocation {
    init(_ dictionay: [String: Any]) {
        self.id = dictionay["id"] as? String ?? "No id"
        self.name = dictionay["name"] as? String ?? "Location name N/A"
        self.website = dictionay["website"] as? String ?? nil
        self.address = dictionay["address"] as? String ?? nil
        self.city = dictionay["city"] as? String ?? nil
        self.state = dictionay["state"] as? String ?? nil
        self.phoneNumber = dictionay["phoneNumber"] as? String ?? "Phone N/A"
        self.hours = dictionay["hours"] as? String ?? "Hours not available"
        self.notes = dictionay["notes"] as? String ?? nil
        self.zipcode = dictionay["zipcode"] as? Int ?? nil
        self.acceptedItems = dictionay["acceptedItems"] as? [String] ?? []
    }
}
