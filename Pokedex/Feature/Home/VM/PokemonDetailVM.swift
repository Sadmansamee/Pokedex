//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

import Moya
import RxRelay
import RxSwift
import SwiftyJSON

final class PokemonDetailVM {
    var homeProvider: MoyaProvider<HomeService>
    var pokemonListViewModel: PokemonListViewModel

    private let _isLoading = BehaviorRelay(value: false)
    private let _alertMessage = PublishSubject<AlertMessage>()
    private let _pokemon = PublishSubject<Pokemon>()

    var onShowingLoading: Observable<Bool> {
        _isLoading.asObservable()
                .distinctUntilChanged()
    }

    var onShowAlert: Observable<AlertMessage> {
        _alertMessage.asObservable()
    }

    var pokemon: Observable<Pokemon> {
        _pokemon.asObservable()
    }

    init(homeProvider: MoyaProvider<HomeService>, pokemonListViewModel: PokemonListViewModel) {
        self.homeProvider = homeProvider
        self.pokemonListViewModel = pokemonListViewModel
    }

    func fetchPokemonDetail() {
        _isLoading.accept(true)

        homeProvider.request(.detail(url: pokemonListViewModel.pokemonListVM.url), completion: { result in
            self._isLoading.accept(false)

            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)
                    let pokemon = Pokemon(fromJson: json)
                    self._pokemon.onNext(pokemon)

                } catch {
                    self._alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self._alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }
}
