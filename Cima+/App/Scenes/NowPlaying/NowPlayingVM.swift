//
//  NowPlayingVM.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation
import RxSwift
import RxCocoa
import XCoordinator
import XCoordinatorRx

class NowPlayingVM: ViewModel {
    
    // MARK: - Inputs
    let input: Input
    
    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let pulledToRefresh: AnyObserver<Void>
        let loadNextPage: AnyObserver<Void>
        let selectedMovie: AnyObserver<MovieCellVM>
    }
    
    // MARK: - Input Private properties
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let pulledToRefreshSubject = PublishSubject<Void>()
    private let loadNextPageSubject = PublishSubject<Void>()
    private let selectedMovieSubject = PublishSubject<MovieCellVM>()
    
    // MARK: - Outputs
    let output: Output
    
    struct Output {
        let moviesCellsVMs: Driver<[MovieCellVM]>
        let isLoading: Driver<Bool>
        let isLoadingNextPage: Driver<Bool>
        let isRefreshing: Driver<Bool>
        let error: Driver<AppError?>
    }
    
    
    // MARK: - Output Private properties
    private let moviesCellsVMsSubject = PublishSubject<[MovieCellVM]>()
    private let isLoadingSubject = PublishSubject<Bool>()
    private let isLoadingNextPageSubject = PublishSubject<Bool>()
    private let isRefreshingSubject = PublishSubject<Bool>()
    private let errorSubject = PublishSubject<AppError?>()
    
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private let router: WeakRouter<AppRoute>
    private let useCase: NowPlayingUseCase
    
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
    private var currentPage = 1
    private var moviesCellsVMs: [MovieCellVM] = []
    
    // MARK: - Initialization
    init(router: WeakRouter<AppRoute>, useCase: NowPlayingUseCase) {
        self.router = router
        self.useCase = useCase
        
        input = Input(
            viewDidLoad: viewDidLoadSubject.asObserver(),
            pulledToRefresh: pulledToRefreshSubject.asObserver(),
            loadNextPage: loadNextPageSubject.asObserver(),
            selectedMovie: selectedMovieSubject.asObserver()
        )
        
        // MARK: outputs drivers
        
        output = Output(
            moviesCellsVMs: moviesCellsVMsSubject.asDriver(onErrorJustReturn: []),
            isLoading: isLoadingSubject.asDriver(onErrorJustReturn: false),
            isLoadingNextPage: isLoadingNextPageSubject.asDriver(onErrorJustReturn: false),
            isRefreshing: isRefreshingSubject.asDriver(onErrorJustReturn: false),
            error: errorSubject.asDriver(onErrorJustReturn: nil)
        )
        
        Observable.merge(viewDidLoadSubject, pulledToRefreshSubject)
            .do(onNext: { [weak self] in self?.currentPage = 1 })
            .startLoadingOn(isLoadingSubject)
            .flatMap { [weak self] _ -> Single<Page<Movie>> in
                guard let self = self else { return .error(AppError.networkError) }
                return self.useCase.getNowPlayingMovies(page: self.currentPage)
            }
            .stopLoadingOn(isLoadingSubject)
            .stopLoadingOn(isRefreshingSubject)
            .subscribe(onNext: { [weak self] page in
                guard let self = self else { return }
                self.moviesCellsVMs = self.buildMoviesCellsVMs(page.results)
                self.moviesCellsVMsSubject.onNext(self.moviesCellsVMs)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                debugPrint("error getting now playing Movies: \(error)")
                self.isLoadingSubject.onNext(false)
                self.errorSubject.onNext(error as? AppError ?? .with(message: error.localizedDescription))
            })
            .disposed(by: disposeBag)
        
        loadNextPageSubject
            .do(onNext: { [weak self] in self?.currentPage += 1 })
            .filter { [weak self] in
                guard let self = self else { return false }
                return self.currentPage < 999
            }
            .startLoadingOn(isLoadingNextPageSubject)
            .flatMap { [weak self] _ -> Single<Page<Movie>> in
                guard let self = self else { return .error(AppError.networkError) }
                return self.useCase.getNowPlayingMovies(page: self.currentPage)
            }
            .stopLoadingOn(isLoadingNextPageSubject)
            .subscribe(onNext: { [weak self] page in
                guard let self = self else { return }
                self.moviesCellsVMs += self.buildMoviesCellsVMs(page.results)
                self.moviesCellsVMsSubject.onNext(self.moviesCellsVMs)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                debugPrint("error getting now playing Movies: \(error)")
                self.isLoadingNextPageSubject.onNext(false)
            })
            .disposed(by: disposeBag)
        
        selectedMovieSubject
            .map { $0.id }
            .flatMap { [unowned self] id in self.router.rx.trigger(.movieDetails(id: id)) }
            .subscribe()
            .disposed(by: disposeBag)
        
    }
    
    private func buildMoviesCellsVMs(_ movies: [Movie]) -> [MovieCellVM] {
        movies.map { movie in
            .init(
                id: movie.id,
                posterPath: imageBaseURL + (movie.posterPath ?? ""),
                title: movie.title,
                vote: "\(movie.vote)",
                releaseDate: movie.releaseDate.toAppDate
            )
        }
    }
    
}
