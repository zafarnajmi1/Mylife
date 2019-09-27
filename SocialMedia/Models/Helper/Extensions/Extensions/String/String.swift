//
//  String.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 08/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

extension String {
//    var localized: String {
//        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
//            // we set a default, just in case
//            UserDefaults.standard.set("en", forKey: "i18n_language")
//            UserDefaults.standard.synchronize()
//        }
//
//        let lang = UserDefaults.standard.string(forKey: "i18n_language")
//
//        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
//        let bundle = Bundle(path: path!)
//
//        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
    
    var localized: String {
        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
            // we set a default, just in case
            //            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }

        let lang = UserDefaults.standard.string(forKey: "i18n_language")

        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)

        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
}

extension String {
    var isValidPhone: Bool {
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let components = self.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        
        return self == filtered
    }
}

extension String {
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}

extension String {
    func semiBold(of size: CGFloat = 16) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font: UIFont.semiBold(ofSize: size)]
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        
        return attributedString
    }
    
    func thin(of size: CGFloat = 16) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font: UIFont.thin(ofSize: size)]
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        
        return attributedString
    }
}
