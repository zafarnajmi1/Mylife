//
//  HomeNavigationController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 11/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Material

class HomeNavigationController: NavigationController {
    open override func prepare() {
        super.prepare()
        
        isMotionEnabled = true
        
        navigationBar.depthPreset = .none
    }
    
    func setModalTransitionTypeZoom() {
        motionNavigationTransitionType = .autoReverse(presenting: .zoom)
    }
    
    func setModalTransitionTypeZoomOut() {
        motionNavigationTransitionType = .autoReverse(presenting: .zoom)
    }
    
    func setModalTransitionTypePush() {
        motionNavigationTransitionType = .auto
    }
}
