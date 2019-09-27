//
//  CameraSnackbarController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 13/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import Material

protocol CameraSnackbarDelegate {
    func snackbarWillShow()
    func snackbarWillHide()
}

class CameraSnackbarController: SnackbarController {
    var snackbarDelegate: CameraSnackbarDelegate?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    open override func prepare() {
        super.prepare()
        delegate = self
        
        edgesForExtendedLayout = [.top, .bottom, .right, .left]
    }
}

extension CameraSnackbarController: SnackbarControllerDelegate {
    func snackbarController(snackbarController: SnackbarController, willShow snackbar: Snackbar) {
        snackbarDelegate?.snackbarWillShow()
        print("snackbarController will show")
    }
    
    func snackbarController(snackbarController: SnackbarController, willHide snackbar: Snackbar) {
        snackbarDelegate?.snackbarWillHide()
        print("snackbarController will hide")
    }
    
    func snackbarController(snackbarController: SnackbarController, didShow snackbar: Snackbar) {
        print("snackbarController did show")
    }
    
    func snackbarController(snackbarController: SnackbarController, didHide snackbar: Snackbar) {
        print("snackbarController did hide")
    }
}
