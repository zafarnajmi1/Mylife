//
//  LanguageViewController.swift
//  SocialMedia
//
//  Created by My Technology on 08/10/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {

    @IBOutlet var remberLbl: UILabel!
    @IBOutlet var rememberBtn: UIButton!
    @IBOutlet var btn_Arabic: UIButton!
    @IBOutlet var btn_English: UIButton!
    
    
    fileprivate func configLocalized() {
       
        rememberBtn.setImage(#imageLiteral(resourceName: "Checkbox-1"), for: .normal)
        rememberBtn.addTarget(self, action: #selector(rememberBtnAction(_:)), for: .touchUpInside)
        btn_Arabic.setTitle("Arabic".localized, for: .normal)
        btn_English.setTitle("English".localized, for: .normal)
        remberLbl.text = "Remember my choice".localized
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configLocalized()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func rememberBtnAction(_ sender:UIButton) {
        if rememberBtn.currentBackgroundImage == #imageLiteral(resourceName: "Checkbox-1") {
            let defaults = UserDefaults.standard
            defaults.set(1, forKey: "Language")
            //rememberBtn.setImage(#imageLiteral(resourceName: "CheckSelected"), for: .normal)
            rememberBtn.setBackgroundImage(#imageLiteral(resourceName: "CheckSelected"), for: .normal)
        }
        else {
            let defaults = UserDefaults.standard
            defaults.set(0, forKey: "Language")
            //rememberBtn.setImage(#imageLiteral(resourceName: "Checkbox-1"), for: .normal)
            rememberBtn.setBackgroundImage(#imageLiteral(resourceName: "Checkbox-1"), for: .normal)
        }
    }
    @IBAction func englishBtnAction(_ sender: UIButton) {
        
      UserDefaults.standard.set("en", forKey: "i18n_language")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
//        UIView.appearance().semanticContentAttribute = .forceRightToLeft
         //self.appDelegate.loginUser()
        self.performSegue(withIdentifier: "signIn", sender: self)
    }
    
    
    @IBAction func arabicBtnAction(_ sender: UIButton) {
        UserDefaults.standard.set("ar", forKey: "i18n_language")
//        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        //self.appDelegate.loginUser()
         self.performSegue(withIdentifier: "signIn", sender: self)
    }
    

   

}
