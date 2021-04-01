//
//  MovieDetailsVC.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 4/1/21.
//

import UIKit
import SkeletonView

class MovieDetailsVC: BaseViewController<MovieDetailsVM> {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var overviewTextView: UITextView!
    
    private var genres: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    private func setupView() {
        // collectionView setup
        genresCollectionView.registerCellNib(cellClass: GenreCell.self)
        genresCollectionView.contentInset = .init(top: 0, left: 30, bottom: 0, right: 30)
        genresCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        // outputs
        viewModel.output.isLoading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                isLoading
                    ? self.view.showAnimatedGradientSkeleton(transition: .crossDissolve(0.2))
                    : self.view.hideSkeleton(transition: .crossDissolve(0.2))
            })
            .disposed(by: disposeBag)
        
        viewModel.output.backdropPath
            .drive(onNext: { [weak self] path in
                guard let self = self else { return }
                self.backdropImageView.sd_setImage(with: URL(string: path))
            })
            .disposed(by: disposeBag)
        
        viewModel.output.posterPath
            .drive(onNext: { [weak self] path in
                guard let self = self else { return }
                self.posterImageView.sd_setImage(with: URL(string: path))
            })
            .disposed(by: disposeBag)
        
        viewModel.output.vote
            .drive(voteLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.voteCount
            .drive(voteCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.releaseDate
            .drive(releaseDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.runtime
            .drive(runtimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.title
            .drive(movieTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.genres
            .do(onNext: { [weak self] genres in self?.genres = genres })
            .drive(genresCollectionView.rx.items(cellIdentifier: String(describing: GenreCell.self), cellType: GenreCell.self)) { _, vm, cell in
                cell.nameLabel.text = vm
                cell.backView.backgroundColor = DesignSystem.getColorFor(vm)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.overview
            .drive(overviewTextView.rx.text)
            .disposed(by: disposeBag)
        
        // inputs
        viewModel.input.viewDidLoad.onNext(())
        
        closeButton.rx.tap
            .bind(to: viewModel.input.closeTapped)
            .disposed(by: disposeBag)

    }
    
}

extension MovieDetailsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont(name: "Avenir-Medium", size: 17.0)
        let genreSize = (genres[indexPath.item] as NSString).size(withAttributes: [.font : font ?? .systemFont(ofSize: 17)])
        let width = CGFloat(genreSize.width) + 25
        return .init(width: width, height: collectionView.bounds.height)
    }
    
}
