//
//  Font.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 17/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    class func regular(ofSize size: CGFloat = AppFont.regularSize) -> UIFont {
        return UIFont(name: AppFont.regular, size: size)!
    }
    
    class func semiBold(ofSize size: CGFloat = AppFont.regularSize) -> UIFont {
        return UIFont(name: AppFont.semiBold, size: size)!
    }
    
    class func light(ofSize size: CGFloat = AppFont.regularSize) -> UIFont {
        return UIFont(name: AppFont.light, size: size)!
    }
    
    class func thin(ofSize size: CGFloat = AppFont.regularSize) -> UIFont {
        return UIFont(name: AppFont.thin, size: size)!
    }
}

extension UIFont {
    class var regular: UIFont {
        return UIFont.regular()
    }
    
    class var semiBold: UIFont {
        return UIFont.semiBold()
    }
    
    class var light: UIFont {
        return UIFont.light()
    }
    
    class var thin: UIFont {
        return UIFont.thin()
    }
}

extension UIFont {
    struct Name {
        static var regular: String {
            return AppFont.regular
        }
        
        static var semiBold: String {
            return AppFont.semiBold
        }
        
        
        static var thin: String {
            return AppFont.thin
        }
        
        
        static var light: String {
            return AppFont.light
        }
    }
}


struct AppFont {
    enum Font: String {
        case regular = "Lato-Regular"
        case semiBold = "Lato-Semibold"
        case light = "Lato-Light"
        case thin = "Lato-Thin"
    }
    
    enum DynamicType: String {
        case body = "UIFontTextStyleBody"
        case headline = "UIFontTextStyleHeadline"
        case subheadline = "UIFontTextStyleSubheadline"
        case footnote = "UIFontTextStyleFootnote"
        case caption1 = "UIFontTextStyleCaption1"
        case caption2 = "UIFontTextStyleCaption2"
    }
    
    static let defaultFontSize: CGFloat = 16
    static let iPhoneFontSize: CGFloat = 16
    static let iPadFontSize: CGFloat = 18
        
    static var regularSize: CGFloat {
        if UIDevice.isiPhone {
            return AppFont.iPhoneFontSize
        } else if UIDevice.isiPad {
            return AppFont.iPadFontSize
        }
        
        return AppFont.defaultFontSize
    }
    
    static var regular: String {
        return AppFont.Font.regular.rawValue
    }
    
    static var semiBold: String {
        return AppFont.Font.semiBold.rawValue
    }
    
    static var thin: String {
        return AppFont.Font.thin.rawValue
    }
    
    static var light: String {
        return AppFont.Font.light.rawValue
    }
    
    
    static func name(of font: AppFont.Font) -> String {
        return font.rawValue
    }
    
    static func font(font: AppFont.Font, size: CGFloat = regularSize) -> UIFont {
        return UIFont(name: font.rawValue, size: size)!
    }
    
    static func font(font: AppFont.Font, style: AppFont.DynamicType = AppFont.DynamicType.body) -> UIFont {
        let preferred = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: style.rawValue)).pointSize
        return UIFont(name: font.rawValue, size: preferred)!
    }
}

