//
//  MoyaHelper.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation

class MoyaHelper {
    
    private init() { }
    
    private enum BuildScheme {
        case debug
        case release
    }

    private static var scheme: BuildScheme = {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }()
    
    static var baseURL: String {
        switch scheme {
        case .debug:
            return "https://api.themoviedb.org/3"
        case .release:
            return "https://api.themoviedb.org/3"
        }
    }
    
    static var apiKey: String {
        return "a11cf1c6708aa614ef05b068a5a68f5e"
    }
    
}
