//
//  PreferanceManager.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 05/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

class Preference {
    private static let preference = UserDefaults.standard
    
    enum Key: String {
        case isFirstTime
        
    }
    
    private init() {
        
    }
    
    fileprivate static func set(_ value: Any, forKey: String) {
        preference.set(value, forKey: forKey)
        preference.synchronize()
    }

    fileprivate static func value(forKey: String) -> Any? {
        return preference.value(forKey: forKey)
    }
    
    private static func save(object: AnyObject, forKey: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        preference.set(data, forKey: forKey)
    }
    
    private static func getObject(forKey: String) -> Any? {
        let decoded  = preference.object(forKey: forKey) as! Data
        return NSKeyedUnarchiver.unarchiveObject(with: decoded)
    }
}


extension Preference {
    static var isFirstTime: Bool {
        guard let _ = self.value(forKey: Key.isFirstTime.rawValue) as? Bool else {
            return false
        }
        
        return true
    }
    
    static func setIsFirstTime(_ isFirstTime: Bool) {
        self.set(isFirstTime, forKey: Key.isFirstTime.rawValue)
    }
}
