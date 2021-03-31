//
//  UIView+Extension.swift
//  GAC Certificates
//
//  Created by admin on 7/6/20.
//  Copyright © 2020 ExpertApps. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
    @IBInspectable
    var isCapsule: Bool {
        get {
            return layer.cornerRadius == frame.height / 2 ? true : false
        }
        set {
            if newValue == true { layer.cornerRadius = frame.height / 2 }
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var onlyTopCornerMasks: Bool {
        get {
            layer.maskedCorners == [.layerMinXMinYCorner, .layerMaxXMinYCorner] ? true : false
        }
        set {
            layer.maskedCorners = newValue == true ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : []
        }
    }
    
    @IBInspectable
    var onlyBottomCornerMasks: Bool {
        get {
            layer.maskedCorners == [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] ? true : false
        }
        set {
            layer.maskedCorners = newValue == true ? [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] : []
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
    func shakeIt() {
        self.transform = CGAffineTransform(translationX: 10, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 15, options: .curveLinear, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    
}
