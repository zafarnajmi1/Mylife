//
//  StateManager.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 07/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit

class StateManager {
    
    static let sharedInstance = StateManager()
    var viewStore: [String: UIView] = [:]
    
    // Associates a view for the given state
    public func addView(_ view: UIView, forState state: String, superview: UIView) {
        viewStore[state] = view
        superview.addSubview(view)
    }
    
    // Remove all views
    public func removeAllViews() {
        for (_, view) in self.viewStore {
            view.removeFromSuperview()
            viewStore = [:]
        }
    }
}
