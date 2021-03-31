//
//  Colors.swift
//  GAC Certificates
//
//  Created by ExpertApps on 11/26/20.
//

import UIKit

extension DesignSystem {
    
    enum Color: String {
        case nowPlaying
        case topRated
        case search
        case background
        case releaseDate
        case title
        case vote
        
        var UIColor: UIColor {
            return UIKit.UIColor(named: self.rawValue)!
        }
    }
}


