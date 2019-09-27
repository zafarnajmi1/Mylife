//
//  TextViewWitjPadding.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 23/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit

@IBDesignable

class TextFieldWithPadding: UITextField {
    @IBInspectable var insetX: CGFloat = 8
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
