//
//	Pokemon.swift

import Foundation
import SwiftyJSON

struct PokemonList {
    var name: String!
    var url: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        name = json["name"].stringValue
        url = json["url"].stringValue
    }

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
