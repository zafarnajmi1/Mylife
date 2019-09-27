//
//  ButtonRounded.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 08/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ButtonRounded: UIButton {
    
    @IBInspectable var cornorRadius: CGFloat = 5 {
        didSet {
            updateCornerRadius()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = cornorRadius
    }
}
