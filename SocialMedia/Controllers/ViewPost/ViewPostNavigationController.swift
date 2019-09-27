//
//  ViewPostNavigationController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 29/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import Material

class MaterialNavigationController: NavigationController {
    open override func prepare() {
        super.prepare()
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        
        v.depthPreset = .none
        v.dividerThickness = 0
        v.dividerColor = .clear
    }
}

