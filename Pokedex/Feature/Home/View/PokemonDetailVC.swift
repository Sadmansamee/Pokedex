//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxSwift
import UIKit

protocol PokemonDetailVCProtocol: AnyObject {
    var onBack: (() -> Void)? { get set }
}

class PokemonDetailVC: UIViewController, HomeStoryboardLodable, PokemonDetailVCProtocol {
    // MARK: - Properties

    var viewModel: PokemonDetailVM!
    var onBack: (() -> Void)?
    private var disposeBag = DisposeBag()
    @IBOutlet var labelHeight: UILabel!

    @IBOutlet var labelWeight: UILabel!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var imageView: UIImageView!
    private var loadingView: UIActivityIndicatorView!
    @IBOutlet var contentView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        curveTopCorners()
    }

    // MARK: - Private functions

    private func bindViewModel() {
        viewModel.fetchPokemonDetail()

        viewModel.onShowingLoading
                .map { [weak self] in
                    if $0 {
                        self?.loadingView.startAnimating()
                    } else {
                        self?.loadingView.stopAnimating()
                    }
                }
                .subscribe()
                .disposed(by: disposeBag)

        viewModel.onShowAlert
                .map { [weak self] in
                    self?.showAlert(title: $0.title ?? "", message: $0.message ?? "")
                }.subscribe()
                .disposed(by: disposeBag)

        viewModel.pokemon
                .map { [weak self] in
                    self?.setPokemonDetail(pokemon: $0)
                }.subscribe()
                .disposed(by: disposeBag)
    }

    private func setUI() {
        let screenSize: CGRect = UIScreen.main.bounds
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height * 0.2)

        setLoadingView()
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
        loadingView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 4)
        loadingView.hidesWhenStopped = true
        view.addSubview(loadingView)
    }

    private func setPokemonDetail(pokemon: Pokemon) {
        contentView.isHidden = false

        imageView.kf.indicatorType = .activity

        if let imageURL = pokemon.imageURL, let url = URL(string: imageURL) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = #imageLiteral(resourceName: "placeholder")
        }

        labelName.text = pokemon.name
        labelWeight.text = pokemon.weight + " grams"
        labelHeight.text = pokemon.height + " meters"
    }

    private func curveTopCorners() {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 32, height: 0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        present(alert, animated: true)
    }
}
