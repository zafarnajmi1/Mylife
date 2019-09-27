//
//  DateTime.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 18/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

extension Date {
    var milliseconds: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
