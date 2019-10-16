//
//  ViewControllerLeakTests+Setup.swift
//  PokedexTests
//
//  Created by sadman samee on 10/10/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Moya
@testable import Pokedex
import Swinject

extension ViewControllerTest {
    /**
     Set up the depedency graph in the DI container
     */
    func setupDependencies() -> Container {
        let container = Container()

        container.register(MoyaProvider<HomeService>.self, factory: { _ in
            MoyaProvider<HomeService>(stubClosure: MoyaProvider.immediatelyStub)
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Model

        container.register(HomeVM.self, factory: { container in

            HomeVM(homeProvider: container.resolve(MoyaProvider<HomeService>.self)!)
        }).inObjectScope(ObjectScope.container)

        container.register(PokemonDetailVM.self, factory: { container in
            let pokemonList = PokemonList(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")

            return PokemonDetailVM(homeProvider: container.resolve(MoyaProvider<HomeService>.self)!, pokemonListViewModel: pokemonList)
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Controllers

        container.storyboardInitCompleted(HomeVC.self) { r, c in
            c.viewModel = r.resolve(HomeVM.self)
        }

        container.storyboardInitCompleted(PokemonDetailVC.self) { r, c in
            c.viewModel = r.resolve(PokemonDetailVM.self)
        }
        return container
    }
}
