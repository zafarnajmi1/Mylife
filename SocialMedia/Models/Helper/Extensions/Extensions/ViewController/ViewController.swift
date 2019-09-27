//
//  ViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 08/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import Material
import NotificationBannerSwift

extension UIViewController {
    var banner: NotificationBanner {
        return NotificationBanner(title: "")
    }
    
    func showBanner(title: String, style: BannerStyle) {
        let banner = NotificationBanner(title: title, style: style)
        banner.show()
    }
    
    func showSuccess(message: String) {
        self.showBanner(title: message, style: .success)
    }
    
    func showError(message: String) {
        self.showBanner(title: message, style: .warning)
    }
}

extension UIViewController: StoryboardIdentifiable { }

extension UIViewController {
   @objc  func prepareView() {
        
    }
}

extension UIViewController {
    var appDelegate: AppDelegate {
        return AppDelegate.appDelegate
    }
}

extension UIViewController {
    func displayNavigationBarActivityIndicator() {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.startAnimating()
        
        navigationItem.titleView = indicator
    }
    
    func dismissNavigationdaBarActivityIndicator() {
        navigationItem.titleView = nil
    }
}

extension UIViewController {
    func performSegue(withIdentifier: String) {
        performSegue(withIdentifier: withIdentifier, sender: self)
    }
}

extension UIViewController {
    func hideStatusBar() {
        DispatchQueue.main.async {
            guard let window = Application.keyWindow else {
                return
            }
            
            window.windowLevel = UIWindow.Level.statusBar + 1
        }
    }
    
    func showStatusBar() {
        DispatchQueue.main.async {
            guard let window = Application.keyWindow else {
                return
            }
            
            window.windowLevel = UIWindow.Level.normal
        }
    }
    
    func hideBackButton() {
        navigationItem.hidesBackButton = true
    }
    
    func addBackButton(backImage: UIImage = #imageLiteral(resourceName: "back")) {
        hideBackButton()
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        let Arback = #imageLiteral(resourceName: "Ar-back")
        if lang == "ar" {
           let backButton = UIBarButtonItem(image: Arback, style: .plain, target: self, action: #selector(onBackButtonClciked))
            navigationItem.leftBarButtonItem  = backButton
            
        }
        else {
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(onBackButtonClciked))
            
            navigationItem.leftBarButtonItem  = backButton
        }



    }
    
    @objc func onBackButtonClciked() {
        navigationController?.popViewController(animated: true)
        dismissVC(completion: nil)
    }
}

extension UIViewController {
    func hideNavigationBar(animated: Bool = false) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func showNavigationBar(animated: Bool = false) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public func transparetNavigationbarWithoutExtensing() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    public func transparetNavigationbar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        edgesForExtendedLayout = .top
    }
    
    public func defaultNavigationbar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .primary
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .primary
        navigationController?.navigationBar.tintColor = .white
        
    }
}

extension UIViewController {
    var isiPhone5: Bool {
        return UIDevice.isiPhone5
    }
}

