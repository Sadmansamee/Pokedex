//
//  PokemonListTest.swift
//  PokedexTests
//
//  Created by sadman samee on 10/10/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import Pokedex

class PokemonListTest: QuickSpec {
    override func spec() {
        describe("PokemonListTest") {
            context("When Data is proper") {
                var pokemonList: PokemonList!
                beforeEach {
                    pokemonList = PokemonList(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
                }

                it("Should Load Detail") {
                    expect(pokemonList?.url).toNot(beNil())
                }
            }

            context("When Data is not proper") {
                var pokemonList: PokemonList!
                beforeEach {
                    pokemonList = PokemonList(name: "bulbasaur", url: "")
                }

                it("Should Load Detail") {
                    expect(pokemonList?.url).to(equal(""))
                }
            }
        }
    }
}
