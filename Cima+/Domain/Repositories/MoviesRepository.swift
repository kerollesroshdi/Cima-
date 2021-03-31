//
//  MoviesRepository.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation
import RxSwift

protocol MoviesRepository {
    func getNowPlaying(page: Int) -> Single<Page<Movie>>
    func getTopRated(page: Int) -> Single<Page<Movie>>
    func searchWith(_ text: String, page: Int) -> Single<Page<Movie>>
    func getMovieDetails(id: Int) -> Single<MovieDetails>
}
