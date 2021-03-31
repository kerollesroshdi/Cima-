//
//  BrowseUseCase.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation
import RxSwift

class BrowseUseCase {
    
    enum Browsing {
        case nowPlaying
        case topRated
    }
    
    private let moviesRepository: MoviesRepository
    private let browsing: Browsing
    
    init(moviesRepository: MoviesRepository, browsing: Browsing) {
        self.moviesRepository = moviesRepository
        self.browsing = browsing
    }
    
    func getMovies(page: Int) -> Single<Page<Movie>> {
        switch browsing {
        case .nowPlaying:
            return moviesRepository.getNowPlaying(page: page)
        case .topRated:
            return moviesRepository.getTopRated(page: page)
        }
        
    }
    
}
