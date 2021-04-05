//
//  MovieDetailsUseCase.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 4/1/21.
//

import Foundation
import RxSwift

class MovieDetailsUseCase {
    
    private let movieID: Int
    private let moviesRepository: MoviesRepository
    
    init(movieID: Int, moviesRepository: MoviesRepository) {
        self.movieID = movieID
        self.moviesRepository = moviesRepository
    }
    
    func getMovieDetails() -> Observable<MovieDetails> {
        moviesRepository.getMovieDetails(id: movieID)
    }
    
}
