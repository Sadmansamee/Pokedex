//
//  Pokemon.swift
//  Pokedex
//
//  Created by sadman samee on 10/10/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Pokemon {
    var id: Int!
    var name: String!
    var height: String!
    var weight: String!
    var imageURL: String?

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        height = json["height"].stringValue
        weight = json["weight"].stringValue
        imageURL = json["sprites"]["front_default"].string
    }
}
