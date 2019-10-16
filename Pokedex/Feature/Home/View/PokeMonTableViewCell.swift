//
//  PokeMonTableViewCell.swift
//  Pokedex
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import UIKit

class PokeMonTableViewCell: UITableViewCell {
    @IBOutlet var labelTitle: UILabel!

    var viewModel: PokemonListViewModel? {
        didSet {
            bindViewModel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func bindViewModel() {
        if let vm = viewModel {
            labelTitle.text = vm.titleVM
        }
    }
}
