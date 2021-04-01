//
//  SearchUseCase.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 4/1/21.
//

import Foundation
import RxSwift

class SearchUseCase {
    
    private let moviesRepository: MoviesRepository
    
    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func searchWith(_ text: String, page: Int) -> Observable<Page<Movie>> {
        moviesRepository.searchWith(text, page: page)
    }
    
}
