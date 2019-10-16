//
//  HomeViewModel.swift
//  Pokedex
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Moya
import RxRelay
import RxSwift
import SwiftyJSON

final class HomeVM {
    private var homeProvider: MoyaProvider<HomeService>

    private var totalCount = 0
    private var limit = 20
    private var offset = 0
    private var isCurrentlyLoading = false
    private var shouldLoadNext = true

    private let _isLoadingMore = PublishSubject<Bool>()
    private let _isLoading = BehaviorRelay(value: false)
    private let _alertMessage = PublishSubject<AlertMessage>()
    private let _cells = BehaviorRelay<[PokemonListViewModel]>(value: [])

    var onShowingLoading: Observable<Bool> {
        _isLoading.asObservable()
                .distinctUntilChanged()
    }

    var onShowingLoadingMore: Observable<Bool> {
        _isLoadingMore.asObservable()
                .distinctUntilChanged()
    }

    var onShowAlert: Observable<AlertMessage> {
        _alertMessage.asObservable()
    }

    var pokemonCells: Observable<[PokemonListViewModel]> {
        _cells.asObservable()
    }

//    var pokemonCellsCount: Int {
//        return _cells.value.count
//    }

    init(homeProvider: MoyaProvider<HomeService>) {
        self.homeProvider = homeProvider
    }

    func fetchPokemons(isLoadingMore: Bool = false) {
        if isCurrentlyLoading {
            return
        }

        if isLoadingMore {
            if totalCount - limit > offset {
                offset += limit
                _isLoadingMore.onNext(true)
            } else {
                _isLoadingMore.onNext(false)
                return
            }
        } else {
            _isLoading.accept(true)
        }

        isCurrentlyLoading = true

        homeProvider.request(.pokemons(offset: offset, limit: limit), completion: { result in

            self._isLoading.accept(false)
            self.isCurrentlyLoading = false

            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)

                    self.totalCount = json["count"].intValue

                    let items = json["results"].arrayValue.compactMap {
                        PokemonList(fromJson: $0)
                    }

                    if(json["next"].string != nil){
                        self._isLoadingMore.onNext(true)
                    }else{
                        self._isLoadingMore.onNext(false)
                    }
                    
                    self._cells.accept(self._cells.value + items)

                } catch {
                    self._alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self._alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }
}
