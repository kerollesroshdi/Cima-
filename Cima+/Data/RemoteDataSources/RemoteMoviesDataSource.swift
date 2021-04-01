//
//  RemoteMoviesDataSource.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation
import Moya
import RxMoya
import RxSwift

class RemoteMoviesDataSource {
    
    let moviesProvider = MoyaProvider<MoviesService>()
    
    func getNowPlaying(page: Int) -> Observable<Page<Movie>> {
        moviesProvider.rx
            .request(.nowPlaying(page: page))
            .catchAppError()
            .map(Page<Movie>.self)
            .asObservable()
    }
    
    func getTopRated(page: Int) -> Observable<Page<Movie>> {
        moviesProvider.rx
            .request(.topRated(page: page))
            .catchAppError()
            .map(Page<Movie>.self)
            .asObservable()
    }
    
    func searchWith(_ text: String, page: Int) -> Observable<Page<Movie>> {
        moviesProvider.rx
            .request(.search(text, page: page))
            .catchAppError()
            .map(Page<Movie>.self)
            .asObservable()
    }
    
    func getMovieDetails(id: Int) -> Observable<MovieDetails> {
        moviesProvider.rx
            .request(.movieDetails(id: id))
            .catchAppError()
            .map(MovieDetails.self)
            .asObservable()
    }
    
}


