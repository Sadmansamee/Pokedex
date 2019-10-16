//
//  PokemonTest.swift
//  PokedexTests
//
//  Created by sadman samee on 10/10/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest
import SwiftyJSON

@testable import Pokedex

class PokemonTest: QuickSpec {
    override func spec() {
        describe("PokemonTest") {
            var json: JSON!

            beforeEach {
                if let path = Bundle.main.path(forResource: MockJson.PokemonDetail.rawValue, ofType: "json") {
                    let url = URL(fileURLWithPath: path)
                    json = try? JSON(data: Data(contentsOf: url))
                }
            }
            context("Model From Json") {
                var pokemon: Pokemon!
                beforeEach {
                    pokemon = Pokemon(fromJson: json)
                }

                it("Data is valid") {
                    expect(pokemon).toNot(beNil())
                    expect(pokemon?.imageURL).toNot(beNil())
                }
            }
        }
    }
}
