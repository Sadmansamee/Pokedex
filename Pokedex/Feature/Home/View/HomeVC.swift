//
//  HomeVC.swift
//  Pokedex
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import RxCocoa
import RxSwift
import Swinject
import UIKit

class HomeVC: UIViewController, HomeStoryboardLodable {
    var onItemSelected: ((PokemonListViewModel) -> Void)?

    @IBOutlet var tableView: UITableView!
    var viewModel: HomeVM!
    private var disposeBag = DisposeBag()

    internal var detailsTransitioningDelegate: BottomModalTransitioningDelegate!

    @IBOutlet var loadingView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pokedex"
        setLoadingView()
        setUpTableView()
        bindViewModel()
        setTableViewModel()
    }

    // MARK: - Private functions

    private func bindViewModel() {
        
        //fetch pokemons from server
        viewModel.fetchPokemons()

        //show initial loading view
        viewModel.onShowingLoading
                .map { [weak self] isLoading in
                    if isLoading {
                        self?.loadingView.startAnimating()
                    } else {
                        self?.loadingView.stopAnimating()
                    }
                }
                .subscribe()
                .disposed(by: disposeBag)

        //to show more loading view
        viewModel.onShowingLoadingMore
                .map { [weak self] in
                    self?.setLoadingMoreView(isLoadingMore: $0)
                }
                .subscribe()
                .disposed(by: disposeBag)

        //to show if there are any alert
        viewModel.onShowAlert
                .map { [weak self] in
                    self?.showAlert(title: $0.title ?? "", message: $0.message ?? "")
                }
                .subscribe()
                .disposed(by: disposeBag)
    }

    private func setViewModelTableView() {
    }

    private func setLoadingView() {
        if #available(iOS 13.0, *) {
            loadingView = UIActivityIndicatorView(style: .large)
        } else {
            // Fallback on earlier versions
            loadingView = UIActivityIndicatorView(style: .gray)
        }
        loadingView.startAnimating()
        loadingView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: view.bounds.width, height: CGFloat(70))
        loadingView.center = view.center
        loadingView.hidesWhenStopped = true
        view.addSubview(loadingView)
    }

    private func setLoadingMoreView(isLoadingMore: Bool) {
        
        if isLoadingMore {
            var spinner: UIActivityIndicatorView!

            if #available(iOS 13.0, *) {
                spinner = UIActivityIndicatorView(style: .medium)
            } else {
                // Fallback on earlier versions
                spinner = UIActivityIndicatorView(style: .gray)
            }
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            tableView.reloadData()
        } else {
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.tableFooterView?.isHidden = true
            tableView.reloadData()
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        present(alert, animated: true)
    }
}

// MARK: - TableView

extension HomeVC {
    // MARK: - View Model TableView

    private func setTableViewModel() {
        //setting delegate
        tableView.rx.setDelegate(self)
                .disposed(by: disposeBag)

        //when cell is selected
        tableView.rx
                .modelSelected(PokemonListViewModel.self)
                .subscribe(
                        onNext: { [weak self] cellType in
                            self?.onItemSelected?(cellType)
                            if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                                self?.tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                            }
                        }
                )
                .disposed(by: disposeBag)

        viewModel.pokemonCells.bind(to: tableView.rx.items) { tableView, _, element in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PokeMonTableViewCell.id) as? PokeMonTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = element

            return cell
        }.disposed(by: disposeBag)

        //For pagination
        tableView.rx.contentOffset
                .flatMap { [weak self] edge in
            self?.tableView.isAtBottomEdge(edgeOffset: 0.0) ?? false
                    ? Observable.just(())
                    : Observable.empty()
        }.asObservable()
        .subscribe { [weak self] edge in
            if let _self = self {
                _self.viewModel.fetchPokemons(isLoadingMore: true)
            }
        }.disposed(by: disposeBag)

    }

    private func setUpTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(PokeMonTableViewCell.nib, forCellReuseIdentifier: PokeMonTableViewCell.id)
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        70
    }
}
