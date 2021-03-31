//
//  Genre.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/31/21.
//

import Foundation

struct Genre: Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
