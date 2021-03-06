//
//  Item.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/14/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct Item {
    var id: String
    var description: String
    var imageURL: String
    var itemName: String
    var materialID: String
    var recylcingProcess: String
    var prepSteps: [String]
    var whyRecycle: [String]
    
    var dict: [String: Any] {
        ["id": id,
         "description": description,
         "imageURL": imageURL,
         "materialID": materialID,
         "recylcingProcess": recylcingProcess,
         "itemName": itemName,
         "prepSteps": prepSteps,
         "whyRecycle": whyRecycle
        ]
    }
}

extension Item {
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? "No ID"
        self.description = dictionary["description"] as? String ?? "No Description Available"
        self.imageURL = dictionary["imageURL"] as? String ?? "no image url"
        self.itemName = dictionary["itemName"] as? String ?? "No Item Name Available"
        self.materialID = dictionary["materialID"] as? String ?? "No material ID Available"
        self.recylcingProcess = dictionary["recylcingProcess"] as? String ?? "No Recylcing Process Available"
        self.prepSteps = dictionary["prepSteps"] as? [String] ?? ["No Preperation Steps Available"]
        self.whyRecycle = dictionary["whyRecycle"] as? [String] ?? ["Information Not Available"]
    }
}
