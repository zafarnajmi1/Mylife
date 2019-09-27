//
//  ResetPasswordViewController.swift
//  SocialMedia
//
//  Created by Apple PC on 11/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ResetPasswordViewController: UIViewController, NVActivityIndicatorViewable {
    
    // @IBOutlet var blurView: UIVisualEffectView!
    let prefs = UserDefaults.standard
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet var formContainer: UIView!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var resetDetailLbl: UILabel!
    @IBOutlet var ResetPasswordHeaderLbl: UILabel!
    @IBOutlet var textFieldNewPassword: UITextField! {
        didSet {
            textFieldNewPassword.placeholder = "New Password".localized
            textFieldNewPassword.delegate = self
        }
    }
    
    @IBOutlet var textFieldConfirmPassword: UITextField! {
        didSet {
            textFieldConfirmPassword.delegate = self
            textFieldConfirmPassword.placeholder = "Confirm Password".localized
        }
    }
    @IBOutlet weak var textFieldOldPassword: UITextField!{
        didSet {
            textFieldOldPassword.delegate = self
            textFieldOldPassword.placeholder = "Old Password".localized
        }
    }
    
    
    var isKeyboardOpened = false
    
    var blurredBackgroundLow: UIImage!
    var blurredBackgroundHigh: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.title = "Reset Password".localized
        ResetPasswordHeaderLbl.text = "Reset Your Password".localized
        resetDetailLbl.text = "Enter your old, new and confirm new password".localized
        sendBtn.setTitle("SEND".localized, for: .normal)
        if(lang == "ar")
        {
            textFieldNewPassword.textAlignment = .right
            textFieldOldPassword.textAlignment = .right
            textFieldConfirmPassword.textAlignment = .right
        }else
        {
            textFieldNewPassword.textAlignment = .left
            textFieldOldPassword.textAlignment = .left
            textFieldConfirmPassword.textAlignment = .left
        }
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         self.navigationController!.navigationBar.backgroundColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController!.navigationBar.backgroundColor = UIColor.primary
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func onButtonResetPasswordClicked(_ sender: UIButton) {
        self.validateForm()
    }
}

extension ResetPasswordViewController {
    override func prepareView() {
        appDelegate.disableKeyboardManager(ResetPasswordViewController.self)
        addBackButton()
        startObservingKeyboard()
        hideKeyboardOnTouch()
    }
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    // MARK: - Form Validation
    func validateForm() {
        guard let oldPassword = textFieldOldPassword.text,
            !oldPassword.isEmpty  else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please enter old password".localized, okAction: {
                    self.textFieldOldPassword.becomeFirstResponder()
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        if oldPassword.characters.count < 6 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Old password require minimum of 6 characters".localized, okAction: {
                self.textFieldOldPassword.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        guard let newPassword = textFieldNewPassword.text,
            !newPassword.isEmpty  else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please enter new password".localized, okAction: {
                    self.textFieldNewPassword.becomeFirstResponder()
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        if newPassword.characters.count < 6 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "New password require minimum of 6 characters".localized, okAction: {
                self.textFieldNewPassword.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
        guard let CPassword = textFieldConfirmPassword.text,
            !CPassword.isEmpty  else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please enter confirm password".localized, okAction: {
                    self.textFieldConfirmPassword.becomeFirstResponder()
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        if CPassword.characters.count < 6 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Confirm password require minimum of 6 characters".localized, okAction: {
                self.textFieldConfirmPassword.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        if CPassword != newPassword {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Password not match".localized, okAction: {
                self.textFieldConfirmPassword.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
      
        print("validate")
        self.changePassword(oldPassword:oldPassword,password:newPassword,cPassword:CPassword)
        
        
    }
    //MARK:- Api Calls
    func changePassword(oldPassword:String,password:String,cPassword:String){
        self.showLoader()
        let parameters : [String: Any] = ["current_password": oldPassword,
                                          "password": password,
                                          "password_confirmation": cPassword
        ]
        
        UserHandler.changePassword(params: parameters as NSDictionary , success: { (success) in
            if success.statusCode == 200{
                
                self.stopAnimating()
                self.prefs.set(password, forKey: "password")
                UserDefaults.standard.synchronize()
                self.textFieldConfirmPassword.text = ""
                self.textFieldNewPassword.text = ""
                self.textFieldOldPassword.text = ""
               // let alertView = AlertView.prepare(title: "Success", message: success.message, okAction: { _ in
               // })
                let alertView = UIAlertController(title: "Success".localized, message: success.message, preferredStyle: UIAlertController.Style.alert)
                alertView.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                   
                }))
                self.present(alertView, animated: true, completion: nil)
            }else{
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
            }
        })
        { (error) in
            print("error = ",error!)
            self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
        }
    }
}

extension ResetPasswordViewController: KeyboardObserver {
    override func keyboardWillShowWithFrame(_ frame: CGRect) {
        if !isKeyboardOpened {
            UIView.animate(withDuration: 0.2) {
//                self.backgroundImageView.image = self.blurredBackgroundHigh
                self.formContainer.frame.origin.y -= frame.height / 4
            }
            isKeyboardOpened = true
        }
    }
    
    override func keyboardWillHideWithFrame(_ frame: CGRect) {
        if isKeyboardOpened {
            UIView.animate(withDuration: 0.2) {
//                self.backgroundImageView.image = self.blurredBackgroundLow
                self.formContainer.frame.origin.y += frame.height / 4
            }
            isKeyboardOpened = false
        }
    }
}


extension ResetPasswordViewController: UITextFieldDelegate {
    
}
