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
    var materialType: String
    var imageURL: String

}

extension Category {
    // failable initializer
    init(_ dictionary: [String: Any]) {
        self.materialType = dictionary["materialType"] as? String ?? "no material type"
        self.imageURL = dictionary["imageURL"] as? String ?? "no image URL"
    }
}
