//
//  ViewModel.swift
//  GAC Certificates
//
//  Created by ExpertApps on 11/26/20.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
