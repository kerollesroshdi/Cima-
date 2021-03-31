//
//  MoviesService.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation
import Moya

enum MoviesService {
    case nowPlaying(page: Int)
    case topRated(page: Int)
    case search(_ text: String, page: Int)
    case movieDetails(id: Int)
}

extension MoviesService: TargetType {
    
    var baseURL: URL {
        return URL(string: MoyaHelper.baseURL)!
    }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "movie/now_playing"
        case .topRated:
            return "movie/top_rated"
        case .search:
            return "search/movie"
        case .movieDetails(let id):
            return "movie/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .nowPlaying, .topRated, .search, .movieDetails:
            return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        let apiKey = MoyaHelper.apiKey
        switch self {
        case .nowPlaying(let page), .topRated(let page):
            return .requestParameters(
                parameters: [
                    "api_key" : apiKey,
                    "page" : page
                ],
                encoding: URLEncoding.default
            )
        case .search(let text, let page):
            return .requestParameters(
                parameters: [
                    "api_key" : apiKey,
                    "query" : text,
                    "page" : page
                ],
                encoding: URLEncoding.default
            )
        case .movieDetails:
            return .requestParameters(
                parameters: [
                    "api_key" : apiKey
                ],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
}
