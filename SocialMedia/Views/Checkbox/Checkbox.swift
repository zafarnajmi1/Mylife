//
//  Checkbox.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 07/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

import UIKit

class CheckBox: UIButton {
    // Provide highlighted and default images in storyboard
    
    // Images
    let checkedImage = #imageLiteral(resourceName: "selected-radio")
    let uncheckedImage = #imageLiteral(resourceName: "radio")
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
                self.setImage(checkedImage, for: .selected)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
