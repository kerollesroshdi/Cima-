//
//  NowPlayingUseCase.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation
import RxSwift

class NowPlayingUseCase {
    
    private let moviesRepository: MoviesRepository
    
    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func getNowPlayingMovies(page: Int) -> Single<Page<Movie>> {
        moviesRepository.getNowPlaying(page: page)
    }
    
}
