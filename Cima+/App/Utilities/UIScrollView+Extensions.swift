//
//  UIScrollView+Extensions.swift
//  Connect
//
//  Created by Kerolles Roshdi on 3/11/21.
//  Copyright © 2021 Expert Apps. All rights reserved.
//

import UIKit

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
