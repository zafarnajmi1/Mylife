//
//  Button.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 08/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func roundCornors(radius: CGFloat = 5) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
