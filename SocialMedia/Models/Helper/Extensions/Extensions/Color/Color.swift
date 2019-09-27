//
//  Color.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 08/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    public class var primary: UIColor {
        return UIColor(hex: Constants.Color.primary)
    }
    
    public class var primaryDark: UIColor {
        return UIColor(hex: Constants.Color.primaryDark)
    }
    
    public class var primaryGreen: UIColor {
        return UIColor(hex: Constants.Color.primaryGreen)
    }
    
    public class var primaryLight: UIColor {
        return UIColor(hex: Constants.Color.primaryLight)
    }
}
