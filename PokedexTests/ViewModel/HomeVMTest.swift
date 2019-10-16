//
//  HomeVMTest.swift
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

class HomeVMTests: QuickSpec {
    override func spec() {
        describe("HomeVMTests") {
            var stubbingProvider: MoyaProvider<HomeService>!
            // var disposeBag: DisposeBag!
            var vm: HomeVM!

            beforeEach {
                // disposeBag = DisposeBag()
                stubbingProvider = MoyaProvider<HomeService>(stubClosure: MoyaProvider.immediatelyStub)
                vm = HomeVM(homeProvider: stubbingProvider)
                vm.fetchPokemons()
            }
            context("when initialized and data count is 20") {
                it("should load Pokemons") {
                    let pokemons = try! vm.pokemonCells.toBlocking().first()
                    expect(pokemons?.count) == 20
                    expect(pokemons?.count).toEventually(beGreaterThanOrEqualTo(20), timeout: 5)
                    expect(pokemons?.first?.titleVM).to(equal("bulbasaur"))
                }
            }
        }
    }
}
