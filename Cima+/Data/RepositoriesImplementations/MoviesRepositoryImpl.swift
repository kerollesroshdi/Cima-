//
//  MoviesRepositoryImpl.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation
import RxSwift

class MoviesRepositoryImpl: MoviesRepository {
    
    let remoteMoviesDataSource = RemoteMoviesDataSource()
    
    func getNowPlaying(page: Int) -> Single<Page<Movie>> {
        remoteMoviesDataSource.getNowPlaying(page: page)
    }
    
    func getTopRated(page: Int) -> Single<Page<Movie>> {
        remoteMoviesDataSource.getTopRated(page: page)
    }
    
    func searchWith(_ text: String, page: Int) -> Single<Page<Movie>> {
        remoteMoviesDataSource.searchWith(text, page: page)
    }
    
    func getMovieDetails(id: Int) -> Single<MovieDetails> {
        remoteMoviesDataSource.getMovieDetails(id: id)
    }
    
    
}
