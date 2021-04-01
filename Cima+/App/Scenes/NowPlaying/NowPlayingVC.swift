//
//  NowPlayingVC.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import UIKit
import RxSwift

class NowPlayingVC: BaseViewController<BrowseVM> {

    @IBOutlet weak var tableView: UITableView!
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private let refresher: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = DesignSystem.Color.nowPlaying.UIColor
        refresh.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        return refresh
    }()
    private let nextPageLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .init(x: 0, y: 0, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.color = DesignSystem.Color.nowPlaying.UIColor
        indicator.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        indicator.startAnimating()
        indicator.isHidden = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }

    private func setupViews() {
        // tableview setup
        tableView.registerCellNib(cellClass: MovieCell.self)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        tableView.refreshControl = refresher
        tableView.tableFooterView = nextPageLoadingIndicator
        tableView.backgroundView = loadingIndicator
        loadingIndicator.center = tableView.center
    }
    
    private func bind() {
        
        // outputs
        viewModel.output.moviesCellsVMs
            .drive(tableView.rx.items(cellIdentifier: String(describing: MovieCell.self), cellType: MovieCell.self)) { index, vm , cell in
                cell.viewModel = vm
            }
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.isRefreshing
            .drive(refresher.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.output.isLoadingNextPage
            .map { !$0 }
            .drive(nextPageLoadingIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.error
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.setupStateViewWith(error)
            })
            .disposed(by: disposeBag)
        
        // inputs
        viewModel.input.viewDidLoad.onNext(())
        
        refresher.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.pulledToRefresh)
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .map { [weak self] _ in
                guard let self = self else { return false }
                return self.tableView.isNearBottomEdge()
            }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map { _ in () }
            .bind(to: viewModel.input.loadNextPage)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MovieCellVM.self)
            .bind(to: viewModel.input.selectedMovie)
            .disposed(by: disposeBag)
    }
    

    
}
