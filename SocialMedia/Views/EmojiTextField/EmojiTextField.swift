//
//  EmojiTextField.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 05/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

class EmojiTextField: UITextField {
    
    enum LanguageMode: String {
        case simple
        case emoji
    }
    
    private var primaryLanguageMode = LanguageMode.simple.rawValue
    
    private var isEmojiKeyboard = false
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if isEmojiKeyboard {
                if mode.primaryLanguage == LanguageMode.emoji.rawValue {
                    return mode
                }
            }
        }
        return nil
    }
    
    func toggleKayboard() {
        
        var mode: LanguageMode
        
        if isEmojiKeyboard {
            mode = LanguageMode.simple
        } else  {
            mode = LanguageMode.emoji
        }
        
        isEmojiKeyboard = !isEmojiKeyboard       
        primaryLanguageMode = mode.rawValue
    }
}
