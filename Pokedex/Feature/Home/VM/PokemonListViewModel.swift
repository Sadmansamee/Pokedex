//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

protocol PokemonListViewModel {
    var pokemonListVM: PokemonList { get }
    var titleVM: String { get }
    var urlVM: String { get }
}

extension PokemonList: PokemonListViewModel {
    var pokemonListVM: PokemonList {
        self
    }

    var titleVM: String {
        name
    }

    var urlVM: String {
        url
    }
}
