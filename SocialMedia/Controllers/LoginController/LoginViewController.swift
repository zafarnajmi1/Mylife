//
//  LoginViewController.swift
//  SocialMedia
//
//  Created by Macbook on 03/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Material
import NVActivityIndicatorView
import SocketIO

extension SegueIdentifiable {
    static var loginController : SegueIdentifier {
        return SegueIdentifier(rawValue: LoginViewController.className)
    }
}

class LoginViewController: UIViewController , NVActivityIndicatorViewable{
    
    // MARK: Outlets
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    //    @IBOutlet var backgroundImageView: UIImageView!
    //@IBOutlet var blurView: UIVisualEffectView!
     var fcmToken = "0"
    @IBOutlet var labelLogin: UILabel!
    var socket:SocketIOClient!
 var manager:SocketManager!
    @IBOutlet var createNewAccountBtn: UIButton!
    @IBOutlet var loginFormView: UIView!
    
    @IBOutlet weak var textFieldEmail: UITextField! {
        didSet {
            textFieldEmail.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldPassword: UITextField! {
        didSet {
            textFieldPassword.delegate = self
        }
    }
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonForgotPin: UIButton!
    
    @IBOutlet var registerLabel: UILabel!
    // MARK: Properties
    var isKeyboardOpened = false
    var myArray = [UserModel]()
    var blurredBackgroundLow: UIImage!
    var blurredBackgroundHigh: UIImage!
    let prefs = UserDefaults.standard
    // MARK: Application Lifecycle
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registerLabel.text = "Register?".localized
        
        labelLogin.text = "Sign In".localized
        textFieldEmail.placeholder = "Email/Phone Number".localized
        textFieldPassword.placeholder = "Password".localized
        
        buttonLogin.setTitle("Login".localized, for: .normal)
        createNewAccountBtn.setTitle("Create New Account".localized, for: .normal)
        
        
        buttonForgotPin.setTitle("Forgot Password?".localized, for: .normal)
        
        
        if lang == "ar" {
            textFieldEmail.textAlignment = .right
            textFieldPassword.textAlignment = .right
        }
        
        
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.updateModel), name: notificationName, object: nil)
        hideKeyboardOnTouch()
        
        guard let usermail = prefs.string(forKey: "useremail"), let password = prefs.string(forKey: "password") else { return }
        
        textFieldEmail.text = usermail
        textFieldPassword.text = password

        autoLogin()
       
    }
    
    func hitConversation(){
        
        
        
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            
            let usertoken = [
                "token":  userToken
            ]
            
            let specs: SocketIOClientConfiguration = [
                .forcePolling(false),
                .forceWebsockets(true),
                .path("/socket.io"),
                .connectParams(usertoken),
                .log(true)
            ]
            
            
//            self.socket  = SocketIOClient(
//                socketURL: NSURL(string: ApiCalls.baseUrlSocket)! as URL as URL,
//                config: specs)
            
            self.manager = SocketManager(socketURL: URL(string:  ApiCalls.baseUrlSocket)! , config: specs)
            
            self.socket = manager.defaultSocket
            
            self.socket.on("connected") { (data, ack) in
                if let arr = data as? [[String: Any]] {
                    if let txt = arr[0]["text"] as? String {
                        print(txt)
                    }
                }
                
            }
//
//            self.socket.on("conversationsList") { (data, ack) in
//                let modified =  (data[0] as AnyObject)
//
//                let dictionary = modified as! [String: AnyObject]
//
//                print(dictionary)
//                //
//                //                let Conversation = ConversationModel.init(dictionary: dictionary as NSDictionary)
//                //
//                //
//                //                self.conversationArray =  (Conversation?.data?.conversations!)!
//                //
//                //
//                //                self.user.conversationArray =  self.conversationArray
//                //
//                //
//                //                self.conversationTableView.delegate = self
//                //                self.conversationTableView.dataSource = self
//                //
//                //                self.conversationTableView.reloadData()
//
//
//                self.stopAnimating()
//
//            }
            
            self.socket.on("userLoggedin") { (data, ack) in
                let modified =  (data[0] as AnyObject)

                let dictionary = modified as! [String: AnyObject]

                print(dictionary)
              //  self.socket.emit("conversationsList")

            }
//
            
            self.socket.on(clientEvent: .connect) {data, emitter in
                // handle connected
                self.socket.emit("userLoggedin")
                
                
            }
            
            self.socket.on(clientEvent: .disconnect, callback: { (data, emitter) in
                //handle diconnect
            })
            
            self.socket.onAny({ (event) in
                //handle event
            })
            
            self.socket.connect()
            // CFRunLoopRun()
            
            // Do any additional setup after loading the view.
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //        startObservingKeyboard()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // textFieldEmail.placeholder = "Email / Phone Number"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //        stopObservingKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - IBActions
    
    @IBAction func onButtonLoginTapped(_ sender: Any) {
        validateForm()
    }
    
    @IBAction func actionRegistration(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegisterViewController")
        self.present(controller, animated: false, completion: nil)
    }
    @IBAction func actonForgotPassword(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        self.present(controller, animated: false, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        }
        else  {
            textFieldPassword.resignFirstResponder()
            self.onButtonLoginTapped("Anything")
        }
        return true
    }
}

// MARK: Keyboard Observer
extension LoginViewController: KeyboardObserver {
    override func keyboardWillShowWithFrame(_ frame: CGRect) {
        if !isKeyboardOpened {
            UIView.animate(withDuration: 0.2) {
                
                //                self.loginFormView.frame.origin.y -= frame.height / 4
            }
            isKeyboardOpened = true
        }
        
    }
    
    override func keyboardWillHideWithFrame(_ frame: CGRect) {
        if isKeyboardOpened {
            UIView.animate(withDuration: 0.2) {
                //                self.loginFormView.frame.origin.y += frame.height / 4
            }
            isKeyboardOpened = false
        }
    }
}

// MARK: Custom

extension LoginViewController {
    func validateForm() {
        hideKeyboardOnTouch()
        
        guard let email = textFieldEmail.text else {
            
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Email Address".localized, okAction: {
                _ = self.textFieldEmail.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
        if !email.isValidEmail {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Valid Email Address".localized, okAction: {
                _ = self.textFieldEmail.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)

            return
        }
        
        guard let password = textFieldPassword.text else {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Password".localized, okAction: {
                _ = self.textFieldPassword.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
        if password.count < 6 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Password should be more than 6 characters".localized, okAction: {
                self.textFieldPassword.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
        
        self.showLoader()
        if let getToken = UserDefaults.standard.value(forKey: "fcmToken") as? String {
            self.fcmToken = getToken
        }
          print(self.fcmToken)
        let parameters : [String: Any] = ["email" : email ,
                                          "password": password,
                                          "fcm_token": self.fcmToken
            
        ]
        
        UserHandler.loginUser(params: parameters as NSDictionary , success: { (success) in
            if(success.data != nil) {
                self.hitConversation()

                UserHandler.sharedInstance.userData = success.data
                self.prefs.set(email, forKey: "useremail")
                UserDefaults.standard.synchronize()
                self.prefs.set(password, forKey: "password")
                UserDefaults.standard.synchronize()
                self.stopAnimating()
                self.appDelegate.loginUser()
                //self.loginUser()
            } else {
                
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: {
                      self.prefs.set("", forKey: "userAuthToken")
                    _ = self.textFieldPassword.becomeFirstResponder()
                })
                self.present(alertView, animated: true, completion: nil)
            }
        }) { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
}

// MARK: API Call
extension LoginViewController{
    func autoLogin() {
        self.showLoader()
        if let getToken = UserDefaults.standard.value(forKey: "fcmToken") as? String {
            self.fcmToken = getToken
        }
        
        print(self.fcmToken)
        let parameters : [String: Any] = ["email" :  UserDefaults.standard.value(forKey: "useremail")! ,
                                          "password":  UserDefaults.standard.value(forKey: "password")!,
                                          "fcm_token": self.fcmToken,
                                          "login_device_type": "ios"
        ]
        
        UserHandler.loginUser(params: parameters as NSDictionary , success: { (success) in
            if(success.data != nil) {
                UserHandler.sharedInstance.userData = success.data
                self.hitConversation()
                self.stopAnimating()
                self.loginUser()
                
            } else if(success.statusCode == 400) {
                self.stopAnimating()
                
                let alertView = AlertView.prepare(title: "Error".localized, message: "Your session has expired, Please re-login".localized, okAction: {
                    self.prefs.set("", forKey: "userAuthToken")
                    _ = self.textFieldEmail.becomeFirstResponder()
                })
                self.present(alertView, animated: true, completion: nil)
                
            } else {
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: {
                      self.prefs.set("", forKey: "userAuthToken")
                    _ = self.textFieldPassword.becomeFirstResponder()
                })
                self.present(alertView, animated: true, completion: nil)
            }
        }) { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
    
    @objc func updateModel() {
        if let getToken = UserDefaults.standard.value(forKey: "fcmToken") as? String {
            self.fcmToken = getToken
        }
          print(self.fcmToken)
        let parameters : [String: Any] = ["email" :  UserDefaults.standard.value(forKey: "useremail")! ,
                                          "password":  UserDefaults.standard.value(forKey: "password")!,
                                          "fcm_token":  self.fcmToken,
                                          "login_device_type": "ios"
        ]
        
        UserHandler.loginUser(params: parameters as NSDictionary , success: { (success) in
            
            if(success.data != nil) {
                self.hitConversation()

                UserHandler.sharedInstance.userData = success.data
                self.loginUser()
            }
            else {
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: { 
                      self.prefs.set("", forKey: "userAuthToken")
                })
                self.present(alertView, animated: true, completion: nil)
            }
        }) { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
}

extension LoginViewController {
    
    func loginUser() {

        
        let homeNavigationController = UIStoryboard.mainStoryboard.instantiateVC(HomeNavigationController.self)!
        let leftViewController: LeftViewController = {
            return UIStoryboard.mainStoryboard.instantiateVC(LeftViewController.self)!
        }()
        if lang == "ar" {
            let homeController = AppNavigationDrawerController(rootViewController: homeNavigationController, leftViewController: nil, rightViewController: leftViewController)
            let homeTabController = homeNavigationController.rootViewController as! MainHomeTabController
            homeTabController.navigationDrawer = homeController
            leftViewController.delegate = homeTabController
            
            let navigationController = UINavigationController(rootViewController: homeController)
            navigationController.navigationBar.isHidden = true
            self.present(navigationController, animated: false, completion: nil)
        }
        else {
            let homeController = AppNavigationDrawerController(rootViewController: homeNavigationController, leftViewController: leftViewController, rightViewController: nil)
            let homeTabController = homeNavigationController.rootViewController as! MainHomeTabController
            homeTabController.navigationDrawer = homeController
            leftViewController.delegate = homeTabController
            
            let navigationController = UINavigationController(rootViewController: homeController)
            navigationController.navigationBar.isHidden = true
            self.present(navigationController, animated: false, completion: nil)
        }
        
        
    }
    
    
}
