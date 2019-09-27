//
//  NotificationObserveable.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 05/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

@objc protocol NotificationObserveable {
    @objc func updateUI()
}

extension NotificationObserveable where Self: UIViewController {
    func addObserver() {
        let notificationName = Notification.Name(Constants.Observer.generic)
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationObserveable.updateUI), name: notificationName, object: nil)
    }
    
    func removeObserver() {
        let notificationName = Notification.Name(Constants.Observer.generic)
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    
    func postToObserver() {
        let notificationName = Notification.Name(Constants.Observer.generic)
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
}
