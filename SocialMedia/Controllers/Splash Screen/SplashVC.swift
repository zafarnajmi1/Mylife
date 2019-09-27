//
//  splashViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 04/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    
    
    var Langchoice:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        Langchoice = defaults.value(forKey:"Language") as? Int
        
        
        
        perform(#selector(SplashVC.ShowSignInVC), with: nil, afterDelay: 1)
    }
    @objc  func ShowSignInVC()
    {
        
        if Langchoice == 1 {
            self.performSegue(withIdentifier: "signIn", sender: self)
        }
            
        else {
            performSegue(withIdentifier: "language", sender: self)
        }
        
        
        
        
        
    }
    
    
    
}
