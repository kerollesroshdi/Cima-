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
    
    private let stateView: StateView = {
        let stateView = StateView()
        stateView.translatesAutoresizingMaskIntoConstraints = false
        return stateView
    }()
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupStateViewWith(_ error :AppError?) {
        if let error = error {
            if stateView.superview == nil {
                view.addSubview(stateView)
                NSLayoutConstraint.activate([
                    stateView.topAnchor.constraint(equalTo: view.topAnchor),
                    stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
            }
            stateView.setupWith(error)
        } else {
            stateView.removeFromSuperview()
        }
    }
    
}
