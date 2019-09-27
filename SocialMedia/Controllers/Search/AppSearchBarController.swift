
//
//  KeyboardObserveable.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 05/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Material
let All_ScreensNotification = "All_ScreensNotification"
let Post_ScreenNotification = "Post_ScreenNotification"
let People_ScreensNotification = "People_ScreensNotification"
let photos_ScreensNotification = "photos_ScreensNotification"
let Videos_ScreensNotification = "Videos_ScreensNotification"

extension SegueIdentifiable {
    static var appSearchBarController : SegueIdentifier {
        return SegueIdentifier(rawValue: AppSearchBarController.className)
    }
}
protocol TestDelegateVC: class {
    
    func SearchString(searchString:String)
}
class AppSearchBarController: SearchBarController {
    private var menuButton: IconButton!
    private var moreButton: IconButton!
    var delegate:TestDelegateVC?
    var buttonBack = UIButton()
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    open override func prepare() {
        super.prepare()
        
        isMotionEnabled = true
        
        hideNavigationBar()
        prepareMenuButton()
        prepareMoreButton()
        prepareStatusBar()
        prepareSearchBar()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showNavigationBar(animated: false)
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "searchString")
        userDefaults.synchronize()
    }
    
    private func prepareMenuButton() {
        if lang == "ar" {
            buttonBack = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            buttonBack.setImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
            buttonBack.addTarget(self, action: #selector(onBackButtonClciked), for: .touchUpInside)
            //menuButton = buttonBack
        }
        else {
            let button = IconButton(image: Icon.arrowBack?.tint(with: UIColor.white))
            button.addTarget(self, action: #selector(onBackButtonClciked), for: .touchUpInside)
            menuButton = button
        }
        
        
        
    }
    
    private func prepareMoreButton() {
        let button = IconButton(image: Icon.search?.tint(with: UIColor.white))
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        moreButton = button
        //cc
    }
    @objc func searchAction() {
//        if ((searchBar.textField.text?.count)! > 0) {
//            if (searchBar.textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
//                return
//            }
//        }
        print("Search")

        let searchType = (UserDefaults.standard.value(forKey: "searchKey") as? String)
        
        if(searchType != nil)
        {
            if(searchType! == "1" ) {
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: All_ScreensNotification), object: nil)
            }
            else if searchType! == "2"
            {
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: Post_ScreenNotification), object: nil)
            }
            else if searchType! == "3"
            {
                
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: People_ScreensNotification), object: nil)
            }
            else if searchType! == "4"
            {
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: photos_ScreensNotification), object: nil)
            }
            else if searchType! == "5"
            {
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: Videos_ScreensNotification), object: nil)
            }
        }
        else
        {
            print("Search Type is Empty")
        }
    }
    private func prepareStatusBar() {
        statusBarStyle = .lightContent
        // Access the statusBar.
        statusBar.backgroundColor = .primary
    }
    
    private func prepareSearchBar() {
        searchBar.clearButton.isHidden = true
        searchBar.textColor = .white
        searchBar.right = 80
        searchBar.top = 40
        searchBar.layer.width = 400
         
        searchBar.tintColor = .white
        searchBar.placeholderColor = UIColor.white.withAlphaComponent(0.6)
        searchBar.textField.font = UIFont.semiBold
        searchBar.backgroundColor = .primary
        searchBar.placeholder = "Search Here".localized
        if(lang == "ar")
        {
        searchBar.textField.textAlignment = .right
        }else
        {
            searchBar.textField.textAlignment = .left
        }
        //searchBar.textField.width = 250
//        var frame = searchBar.frame
//        frame.origin.x = 20
//        frame.size.width -= 40
//        searchBar.frame = frame // set new frame with margins
        
        if lang == "ar" {
            
            searchBar.leftViews = [moreButton]
            searchBar.rightViews = [buttonBack]
            //searchBar.textField.textAlignment = .right
            
            
        }
        else {
            searchBar.leftViews = [menuButton]
            searchBar.rightViews = [moreButton]
            searchBar.textField.textAlignment = .left
            
        }
    }
}

