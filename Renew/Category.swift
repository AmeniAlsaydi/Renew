//
//  Categories.swift
//  Renew
//
//  Created by Amy Alsaydi on 5/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import Firebase

struct Category {
    var id: String
    var materialType: String
    var imageURL: String
}

extension Category {
    init?(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? "no id"
        self.materialType = dictionary["materialType"] as? String ?? "no material type"
        self.imageURL = dictionary["imageURL"] as? String ?? "no image URL"
    }
}
