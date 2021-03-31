//
//  RxSwift+Extensions.swift
//  Connect
//
//  Created by Kerolles Roshdi on 3/10/21.
//  Copyright © 2021 Expert Apps. All rights reserved.
//

import Foundation
import RxSwift


extension Observable where Element: Any {
    
    func startLoadingOn(_ subject: PublishSubject<Bool>) -> Observable<Element> {
        return self.do(onNext: { _ in
            subject.onNext(true)
        })
    }
    
    func stopLoadingOn(_ subject: PublishSubject<Bool>) -> Observable<Element> {
        return self.do(onNext: { _ in
            subject.onNext(false)
        })
    }
    
}
