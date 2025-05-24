//
//  UIView+Extension.swift
//  Abhi Babriya
//
//  Created by Abhi Babriya on 24/05/25.
//

import UIKit

extension UIView {
    @IBInspectable var isCircular: Bool {
        get {
            return layer.cornerRadius == min(bounds.width, bounds.height) / 2
        }
        set {
            if newValue {
                let minSide = min(bounds.width, bounds.height)
                layer.cornerRadius = minSide / 2
                layer.masksToBounds = true
            }
        }
    }
}
