//
//  BaseViewController.swift
//  GAC Certificates
//
//  Created by ExpertApps on 11/26/20.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController<T: ViewModel>: UIViewController {
    var viewModel: T!
    let disposeBag = DisposeBag()
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
