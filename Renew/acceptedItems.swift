//
//  acceptedItems.swift
//  Renew
//
//  Created by Amy Alsaydi on 8/28/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct AcceptedItems {
    var itemName: String
    var notes: String?
    var dropoff: Bool
    var pickup: Bool
}

extension AcceptedItems {
    init(_ dictionary: [String: Any]) {
        self.itemName = dictionary["itemName"] as? String ?? "No item name"
        self.notes = dictionary["notes"] as? String ?? nil
        self.dropoff = dictionary["dropoff"] as? Bool ?? false
        self.pickup = dictionary["pickup"] as? Bool ?? false
    }
}
