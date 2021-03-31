//
//  MovieCell.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import UIKit
import SDWebImage

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var viewModel: MovieCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            posterImageView.sd_setImage(with: URL(string: viewModel.posterPath))
            titleLabel.text = viewModel.title
            voteLabel.text = viewModel.vote
            releaseDateLabel.text = viewModel.releaseDate
        }
    }
}
