//
//  String+Extensions.swift
//  Connect
//
//  Created by ExpertApps on 28/02/2021.
//

import Foundation
import CommonCrypto

extension String {
        
    var backslashRemoved: String {
        return self.replacingOccurrences(of: "\\", with: "/")
    }
        
    var toAppDate: String {
        
        let apiDateFormatter = DateFormatter()
        apiDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let appDateFormatter = DateFormatter()
        appDateFormatter.dateFormat = "d MMMM yyyy"
        
        let apiDate = apiDateFormatter.date(from: self) ?? Date()
        return appDateFormatter.string(from: apiDate)
    }

}

extension Optional where Wrapped == String {
    
    var orEmpty: String {
        self ?? ""
    }
    
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
    
}
