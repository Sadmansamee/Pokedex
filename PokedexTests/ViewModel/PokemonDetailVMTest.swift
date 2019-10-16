//
//  PokemonDetailVMTest.swift
//  PokedexTests
//
//  Created by sadman samee on 10/10/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Moya
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest

@testable import Pokedex

class PokemonDetailVMTest: QuickSpec {
    override func spec() {
        let stubbingProvider: MoyaProvider<HomeService> = MoyaProvider<HomeService>(stubClosure: MoyaProvider.immediatelyStub)
        var vm: PokemonDetailVM!
        var disposeBag = DisposeBag()
        var pokemon: Pokemon

        describe("PokemonDetailVMTest") {
            beforeEach {
                disposeBag = DisposeBag()
                let pokemonList = PokemonList(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
                vm = PokemonDetailVM(homeProvider: stubbingProvider, pokemonListViewModel: pokemonList.pokemonListVM)
                vm.fetchPokemonDetail()
            }

            context("When Data is proper") {
                it("pokemon name") {
                    vm.pokemon.map { [weak self] in
                                expect($0.name).to(beNil())
                            }.subscribe()
                            .disposed(by: disposeBag)
                }
            }
        }
    }
}
