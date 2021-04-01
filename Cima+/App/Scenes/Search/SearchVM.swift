//
//  SearchVM.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 4/1/21.
//

import Foundation
import RxSwift
import RxCocoa
import XCoordinator
import XCoordinatorRx

class SearchVM: ViewModel {
    
    // MARK: - Inputs
    let input: Input
    
    struct Input {
        let searchWithText: AnyObserver<String>
        let loadNextPage: AnyObserver<Void>
        let selectedMovie: AnyObserver<MovieCellVM>
    }
    
    // MARK: - Input Private properties
    private let searchWithTextSubject = PublishSubject<String>()
    private let loadNextPageSubject = PublishSubject<Void>()
    private let selectedMovieSubject = PublishSubject<MovieCellVM>()
    
    // MARK: - Outputs
    let output: Output
    
    struct Output {
        let moviesCellsVMs: Driver<[MovieCellVM]>
        let isLoading: Driver<Bool>
        let isLoadingNextPage: Driver<Bool>
        let error: Driver<AppError?>
    }
    
    // MARK: - Output Private properties
    private let moviesCellsVMsSubject = PublishSubject<[MovieCellVM]>()
    private let isLoadingSubject = PublishSubject<Bool>()
    private let isLoadingNextPageSubject = PublishSubject<Bool>()
    private let errorSubject = PublishSubject<AppError?>()
    
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
    private var searchText = ""
    private var currentPage = 1
    private var moviesCellsVMs: [MovieCellVM] = []
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private let router: WeakRouter<AppRoute>
    private let useCase: SearchUseCase
    
    // MARK: - Initialization
    init(router: WeakRouter<AppRoute>, useCase: SearchUseCase) {
        self.router = router
        self.useCase = useCase
        
        input = Input(
            searchWithText: searchWithTextSubject.asObserver(),
            loadNextPage: loadNextPageSubject.asObserver(),
            selectedMovie: selectedMovieSubject.asObserver()
        )
        
        // MARK: outputs drivers
        
        output = Output(
            moviesCellsVMs: moviesCellsVMsSubject.asDriver(onErrorJustReturn: []),
            isLoading: isLoadingSubject.asDriver(onErrorJustReturn: false),
            isLoadingNextPage: isLoadingNextPageSubject.asDriver(onErrorJustReturn: false),
            error: errorSubject.asDriver(onErrorJustReturn: nil)
        )
        
        searchWithTextSubject
            .do(onNext: { [weak self] text in
                guard let self = self else { return }
                self.currentPage = 1
                self.searchText = text
                self.moviesCellsVMs.removeAll()
                self.moviesCellsVMsSubject.onNext([])
                self.errorSubject.onNext(nil)
            })
            .filter { !$0.isEmpty }
            .startLoadingOn(isLoadingSubject)
            .flatMap { [weak self] text -> Observable<Event<Page<Movie>>> in
                guard let self = self else { return .error(AppError.networkError) }
                return self.useCase.searchWith(text, page: self.currentPage).materialize()
            }
            .stopLoadingOn(isLoadingSubject)
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
                return self.useCase.searchWith(self.searchText, page: self.currentPage).materialize()
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
                default :
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
