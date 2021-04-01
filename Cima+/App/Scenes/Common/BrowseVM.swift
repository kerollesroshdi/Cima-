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

class BrowseVM: ViewModel {
    
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
    private let useCase: BrowseUseCase
    
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
    private var currentPage = 1
    private var moviesCellsVMs: [MovieCellVM] = []
    
    // MARK: - Initialization
    init(router: WeakRouter<AppRoute>, useCase: BrowseUseCase) {
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
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                self.currentPage = 1
                self.errorSubject.onNext(nil)
            })
            .startLoadingOn(isLoadingSubject)
            .flatMap { [weak self] _ -> Observable<Event<Page<Movie>>> in
                guard let self = self else { return .error(AppError.networkError) }
                return self.useCase.getMovies(page: self.currentPage).materialize()
            }
            .stopLoadingOn(isLoadingSubject)
            .stopLoadingOn(isRefreshingSubject)
            .stopLoadingOn(isLoadingNextPageSubject)
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .next(let page):
                    self.moviesCellsVMs = self.buildMoviesCellsVMs(page.results)
                    self.moviesCellsVMsSubject.onNext(self.moviesCellsVMs)
                case .error(let error):
                    debugPrint("error getting now playing Movies: \(error)")
                    self.isLoadingSubject.onNext(false)
                    self.isRefreshingSubject.onNext(false)
                    self.errorSubject.onNext(error as? AppError ?? .with(message: error.localizedDescription))
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
                
        loadNextPageSubject
            .skipUntil(isLoadingSubject)
            .withLatestFrom(isLoadingNextPageSubject)
            .filter { !$0 }
            .map { _ in () }
            .do(onNext: { [weak self] in self?.currentPage += 1 })
            .filter { [weak self] in
                guard let self = self else { return false }
                return self.currentPage < 999
            }
            .startLoadingOn(isLoadingNextPageSubject)
            .flatMap { [weak self] _ -> Observable<Event<Page<Movie>>> in
                guard let self = self else { return .error(AppError.networkError) }
                return self.useCase.getMovies(page: self.currentPage).materialize()
            }
            .stopLoadingOn(isLoadingNextPageSubject)
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .next(let page):
                    self.moviesCellsVMs += self.buildMoviesCellsVMs(page.results)
                    self.moviesCellsVMsSubject.onNext(self.moviesCellsVMs)
                case .error(let error):
                    debugPrint("error getting now playing Movies: \(error)")
                    self.isLoadingNextPageSubject.onNext(false)
                default:
                    break
                }
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
