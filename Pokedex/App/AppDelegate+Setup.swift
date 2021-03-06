//
//  AppDelegate+Setup.swift
//  Pokedex
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Moya
import Swinject

extension AppDelegate {
    /**
     Set up the depedency graph in the DI container
     */
    internal func setupDependencies() {
        // MARK: - Providers

        container.register(MoyaProvider<HomeService>.self, factory: { _ in
            MoyaProvider<HomeService>()
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Model

        container.register(HomeVM.self, factory: { container in
            HomeVM(homeProvider: container.resolve(MoyaProvider<HomeService>.self)!)
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Controllers

        container.storyboardInitCompleted(HomeVC.self) { r, c in
            c.viewModel = r.resolve(HomeVM.self)
        }

        container.storyboardInitCompleted(PokemonDetailVC.self) { _, _ in
        }
    }
}
