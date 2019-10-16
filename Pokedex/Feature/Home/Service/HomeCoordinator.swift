//
//  HomeCoordinator.swift
//  Pokedex
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Moya
import Swinject

final class HomeCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?
    let container: Container

    // MARK: - Vars & Lets

    let navigationController: UINavigationController

    // MARK: - Coordinator

    override func start() {
        showHomeVC()
    }

    // MARK: - Init

    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Private metods

    private func showHomeVC() {
        let vc = container.resolveViewController(HomeVC.self)

        vc.onItemSelected = { viewModel in
            self.showPokemonDetailVC(viewModel: PokemonDetailVM(homeProvider: self.container.resolve(MoyaProvider<HomeService>.self)!, pokemonListViewModel: viewModel), sourceVC: vc)
        }
        navigationController.pushViewController(vc, animated: true)
    }

    private func showPokemonDetailVC(viewModel: PokemonDetailVM, sourceVC: HomeVC) {
        let vc = container.resolveViewController(PokemonDetailVC.self)
        vc.onBack = { [unowned self] in
            self.navigationController.popViewController(animated: true)
        }
        vc.viewModel = viewModel
        sourceVC.detailsTransitioningDelegate = BottomModalTransitioningDelegate(from: sourceVC, to: vc)

        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sourceVC.detailsTransitioningDelegate

        navigationController.present(vc, animated: true, completion: nil)
    }
}
