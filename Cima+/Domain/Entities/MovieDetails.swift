//
//  MovieDetails.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation

struct MovieDetails: Decodable {
    let isPlus18: Bool
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let genres: [Genre]
    let runTime: Int
    let releaseDate: String
    let vote: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isPlus18 = "adult"
        case title = "title"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview = "overview"
        case genres =  "genres"
        case runTime = "runtime"
        case releaseDate = "release_date"
        case vote = "vote_average"
        case voteCount = "vote_count"
    }
}
