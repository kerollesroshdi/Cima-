//
//  Page.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation

struct Page<T: Decodable>: Decodable {
    let page: Int
    let total: Int
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case total = "total_pages"
        case results = "results"
    }
}


