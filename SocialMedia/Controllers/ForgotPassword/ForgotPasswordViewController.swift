//
//  ForgotPasswordViewController.swift
//  SocialMedia
//
//  Created by Apple PC on 11/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Material
import NVActivityIndicatorView


class ForgotPasswordViewController: UIViewController, NVActivityIndicatorViewable {
    
    // @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var forgetPasswordLabel: UILabel!
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var forgetPasswordDetailLbl: UILabel!
    
    @IBOutlet var backgroundImageView: UIImageView!

    @IBOutlet var formContainer: UIView!
    
    @IBOutlet weak var textFieldEmail: TextField! {
        didSet {
            textFieldEmail.delegate = self
        }
    }
    
    var isKeyboardOpened = false
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if lang == "ar" {
            backButton.setImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
        }
        else {
            backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        sendButton.setTitle("SEND".localized, for: .normal)
        textFieldEmail.placeholder = "Email".localized
        forgetPasswordLabel.text = "Forgot Your Password?".localized
        forgetPasswordDetailLbl.text = "Enter your email below to receive your reset password instruction".localized
        
        if lang == "ar" {
            
            textFieldEmail.textAlignment = .right
           
        }
        
        showNavigationBar()
//        transparetNavigationbar()
//        addBackButton()
        
        startObservingKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideNavigationBar()
        
        stopObservingKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
     // MARK: - Form Validation
    func validateForm() {
        guard let email = textFieldEmail.text,
            !email.isEmpty  else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Valid Email Address".localized, okAction: {
                    self.textFieldEmail.becomeFirstResponder()

                })
                self.present(alertView, animated: true, completion: nil)

                return
        }

        if !email.isValidEmail {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Valid Email Address".localized, okAction: {
                self.textFieldEmail.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)

            return
        }
        print("validate")
        self.forgotPassword(email:email)
        
        
    }
    //MARK:- Api Calls
    func forgotPassword(email:String){
        self.showLoader()
        let parameters : [String: Any] = ["email": email]
        
        UserHandler.forgotPassword(params: parameters as NSDictionary , success: { (success) in
            if success.statusCode == 200{
                
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Success".localized, message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
                self.textFieldEmail.text = ""
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
    
    @IBAction func onButtonForgotPasswordClicked(_ sender: UIButton) {
         validateForm()
        
    }
    @IBAction func actionBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: false, completion: nil)
    }
    
}

extension ForgotPasswordViewController: KeyboardObserver {
     override func keyboardWillShowWithFrame(_ frame: CGRect) {
        if !isKeyboardOpened {
            UIView.animate(withDuration: 0.2) {
//                self.formContainer.frame.origin.y -= frame.height / 5
            }
            isKeyboardOpened = true
        }
    }
    
    override func keyboardWillHideWithFrame(_ frame: CGRect) {
        if isKeyboardOpened {
            UIView.animate(withDuration: 0.2) {
//                self.formContainer.frame.origin.y += frame.height / 5
            }
            isKeyboardOpened = false
        }
    }
}


extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            dismissKeyboard()
            
            return false
        }
        
        return true
    }
}
