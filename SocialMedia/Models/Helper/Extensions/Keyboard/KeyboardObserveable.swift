//
//  KeyboardObserveable.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 05/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardHandler {
    func keyboardWillOpen(keyboardSize: CGRect)
    func keyboardWillClose(keyboardSize: CGRect)
}

extension KeyboardHandler {
    func keyboardWillOpen(keyboardSize: CGRect) {
        
    }
    
    func keyboardWillClose(keyboardSize: CGRect) {
        
    }
}

extension KeyboardObserveable where Self: KeyboardHandler {
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillOpen(keyboardSize: keyboardSize)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillClose(keyboardSize: keyboardSize)
        }
    }
}

@objc protocol KeyboardObserveable {
    @objc optional func keyboardWillShow(notification: NSNotification)
    @objc optional func keyboardWillHide(notification: NSNotification)
}

extension KeyboardObserveable where Self: UIViewController {
    
    func hideKeyboardOnTouch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardObserveable.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardObserveable.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    }

protocol KeyboardObserver {
    
}

extension KeyboardObserver where Self: UIViewController {
    func hideKeyboardOnTouch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func startObservingKeyboard() {
        hideKeyboardWhenTappedAround()
        
        addKeyboardWillShowNotification()
        addKeyboardWillHideNotification()
    }
    
    func stopObservingKeyboard() {
        removeKeyboardWillShowNotification()
        removeKeyboardWillHideNotification()
    }
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}
