//
//  SwiftyGalleryViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 11/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

class SwiftyGalleryNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

class NavigationToGalleryController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = UIStoryboard.mainStoryboard.instantiateVC(ImageGalleryViewController.self)!
        self.pushVC(controller)
    }
}
