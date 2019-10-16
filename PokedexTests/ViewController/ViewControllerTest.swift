//
//  HomeVCTest.swift
//  PokedexTests
//
//  Created by sadman samee on 10/12/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

import Nimble
@testable import Pokedex
import Quick
import Swinject
import XCTest

class ViewControllerTest: QuickSpec {
    override func spec() {
        let container = setupDependencies()

        describe("HomeVC") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    container.resolveViewController(HomeVC.self)
                }

                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("PokemonDetailVC") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    container.resolveViewController(PokemonDetailVC.self)
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }


        describe("HomeVC") {
            var subject: HomeVC!

            beforeEach {
                subject = container.resolveViewController(HomeVC.self)
                _ = subject.view
                subject.viewModel.fetchPokemons()
            }

            context("when view is loaded") {
                it("should have pokemons loaded") {
                    expect(subject.tableView.numberOfRows(inSection: 0)).to(beGreaterThan(20))
                }
            }
        }

        describe("PokemonDetailVC") {
            var subject: PokemonDetailVC!

            beforeEach {
                subject = container.resolveViewController(PokemonDetailVC.self)
                _ = subject.view
                subject.viewModel.fetchPokemonDetail()
            }

            context("when view is loaded") {
                it("should have proper title pokemons loaded") {
                    expect(subject.labelName.text).to(equal("bulbasaur"))
                }
            }
        }


    }
}
