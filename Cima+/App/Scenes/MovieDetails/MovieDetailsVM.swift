//
//  MovieDetailsVM.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 4/1/21.
//

import Foundation
import RxSwift
import RxCocoa
import XCoordinator
import XCoordinatorRx

class MovieDetailsVM: ViewModel {
    
    // MARK: - Inputs
    let input: Input
    
    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let closeTapped: AnyObserver<Void>
    }
    
    // MARK: - Input Private properties
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let closeTappedSubject = PublishSubject<Void>()
    
    // MARK: - Outputs
    let output: Output
    
    struct Output {
        let isLoading: Driver<Bool>
        let backdropPath: Driver<String>
        let posterPath: Driver<String>
        let vote: Driver<String>
        let voteCount: Driver<String>
        let releaseDate: Driver<String>
        let runtime: Driver<String>
        let title: Driver<String>
        let genres: Driver<[String]>
        let overview: Driver<String>
        let error: Driver<AppError?>
    }
    
    
    // MARK: - Output Private properties
    private let isLoadingSubject = PublishSubject<Bool>()
    private let movieDetails = PublishSubject<MovieDetails>()
    private let errorSubject = PublishSubject<AppError?>()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private let router: WeakRouter<AppRoute>
    private let useCase: MovieDetailsUseCase
    
    // MARK: - Initialization
    init(router: WeakRouter<AppRoute>, useCase: MovieDetailsUseCase) {
        self.router = router
        self.useCase = useCase
        
        input = Input(
            viewDidLoad: viewDidLoadSubject.asObserver(),
            closeTapped: closeTappedSubject.asObserver()
        )
        
        // MARK: outputs drivers
        
        output = Output(
            isLoading: isLoadingSubject.asDriver(onErrorJustReturn: false),
            backdropPath: movieDetails.map { .imageBaseURL + ($0.backdropPath ?? "") }.asDriver(onErrorJustReturn: ""),
            posterPath: movieDetails.map { .imageBaseURL + ($0.posterPath ?? "") }.asDriver(onErrorJustReturn: ""),
            vote: movieDetails.map { "\($0.vote)" }.asDriver(onErrorJustReturn: ""),
            voteCount: movieDetails.map { "\($0.voteCount) votes" }.asDriver(onErrorJustReturn: ""),
            releaseDate: movieDetails.map { $0.releaseDate.toAppDate }.asDriver(onErrorJustReturn: ""),
            runtime: movieDetails.map { "\($0.runTime) mins" }.asDriver(onErrorJustReturn: ""),
            title: movieDetails.map { $0.title }.asDriver(onErrorJustReturn: ""),
            genres: movieDetails.map { $0.genres.map { $0.name } }.asDriver(onErrorJustReturn: []),
            overview: movieDetails.map { $0.overview }.asDriver(onErrorJustReturn: ""),
            error: errorSubject.asDriver(onErrorJustReturn: nil)
        )
        
        viewDidLoadSubject
            .startLoadingOn(isLoadingSubject)
            .flatMap { [weak self] _ -> Observable<Event<MovieDetails>> in
                guard let self = self else { return .error(AppError.networkError) }
                return self.useCase.getMovieDetails().materialize()
            }
            .stopLoadingOn(isLoadingSubject)
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .next(let details):
                    self.movieDetails.onNext(details)
                case .error(let error):
                    debugPrint("error getting movie details: \(error)")
                    self.errorSubject.onNext(error as? AppError ?? .with(message: error.localizedDescription))
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        
        closeTappedSubject
            .flatMap { [unowned self] in self.router.rx.trigger(.dismiss) }
            .subscribe()
            .disposed(by: disposeBag)
        
    }
    
}
