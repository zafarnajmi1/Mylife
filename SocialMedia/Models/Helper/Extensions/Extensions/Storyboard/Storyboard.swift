//
//  Storyboard.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 10/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit


import UIKit

extension UIStoryboard {
    class func viewController(identifier: String) -> UIViewController {
        return UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: identifier)
    }
}

extension UIStoryboard {
    public static var mainStoryboard: UIStoryboard {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return UIStoryboard()
        }
        
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    public func instantiateVC<T>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        if let vc = instantiateViewController(withIdentifier: storyboardID) as? T {
            return vc
        } else {
            return nil
        }
    }
}



protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController {
    static func instantiateFromStoryboard() -> Self {
        return UIStoryboard.mainStoryboard.instantiateVC(self)!
    }
}

extension UIStoryboard {
    
    public func instantiateViewController<T>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        if let controller = instantiateViewController(withIdentifier: storyboardID) as? T {
            return controller
        } else {
            return nil
        }
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}

extension UIViewController {
    func segueTo(controller: SegueIdentifier) {
        performSegue(withIdentifier: controller.rawValue)
    }
    
    func segueTo(controller: SegueIdentifier, withDelay: Bool = false, completion: (() -> Swift.Void)?) {
        
        if withDelay {
            completion?()
            
            Timer.after(0.2) {
                self.segueTo(controller: controller)
            }
        } else {
            CATransaction.begin()
            self.segueTo(controller: controller)
            CATransaction.setCompletionBlock({
                completion?()
            })
            CATransaction.commit()
        }
    }
}


// Segue extension
struct SegueIdentifier: RawRepresentable {
    typealias RawValue = String
    var rawValue: String
}

protocol SegueIdentifiable {
    
}

extension SegueIdentifier : SegueIdentifiable {
    
}
