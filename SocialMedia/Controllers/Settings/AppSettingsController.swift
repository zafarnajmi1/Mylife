//
//  AppSettingsController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 11/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension SegueIdentifiable {
    static var appSettingsController : SegueIdentifier {
        return SegueIdentifier(rawValue: AppSettingsController.className)
    }
}

class AppSettingsController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var lblNotificaiton: UILabel!
    @IBOutlet weak var lblFriendRequest: UILabel!
    @IBOutlet weak var oltFriendRequest: UISwitch!
    @IBOutlet var arabicSelection: UIButton!
    
    @IBOutlet var englishSelection: UIButton!
    @IBOutlet weak var lblRequestAccepted: UILabel!
    
    @IBOutlet weak var oltRequestAccepted: UISwitch!
    @IBOutlet weak var lblPostLike: UILabel!
    @IBOutlet weak var oltPostLike: UISwitch!
    @IBOutlet weak var lblTitleLanguages: UILabel!
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var oltComments: UISwitch!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblResetPassword: UILabel!
    @IBOutlet weak var lblPostShare: UILabel!
    @IBOutlet weak var oltPostShare: UISwitch!
    
    @IBOutlet weak var oltResetPassword: UIButton!
    var changeLanguage: Bool = true
    @IBOutlet var lblArabic: UILabel!
    var isFriendRequest = 0
    var isRequestAccepted = 0
    var isPostLike = 0
    var isPostShare = 0
    var isPostComment = 0
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var objUser: UserLoginData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oltFriendRequest.isOn = true
        oltComments.isOn = true
        oltPostLike.isOn = true
        oltPostShare.isOn = true
        oltRequestAccepted.isOn = true
        
        
        
        
        
        
        //        if lang == "ar" {
        //             UIView.appearance().semanticContentAttribute = .forceRightToLeft
        //        }
        
        // Do any additional setup after loading the view.
        objUser = UserHandler.sharedInstance.userData
        self.setupViews()
        addRightButton()
        
        lblFriendRequest.text = "Friend Request".localized
        lblRequestAccepted.text = "Request Accepted".localized
        lblPostLike.text = "Post Like".localized
        lblComment.text = "Post Comment".localized
        
        lblPostShare.text = "Post Share".localized
        lblTitleLanguages.text = "App Language".localized
        lblEnglish.text = "English".localized
        lblArabic.text = "Arabic".localized
        
        lblResetPassword.text = "Reset Your Password?".localized
        lblNotificaiton.text = "Get Notification For".localized
        
        
        
        
        
        arabicSelection.addTarget(self, action: #selector(arabicBtnAction(_:)), for: .touchUpInside)
        englishSelection.addTarget(self, action: #selector(englishBtnAction(_:)), for: .touchUpInside)
        
        
        //        if lang == "ar" {
        //            //arabicSelection.setBackgroundImage(#imageLiteral(resourceName: "RadioSelected"), for: .normal)
        //            arabicSelection.setImage(UIImage.init(named: "RadioSelected-1"), for: .normal)
        //            englishSelection.setImage(UIImage.init(named: "Radio-2"), for: .normal)
        //        }
        //        else {
        ////            arabicSelection.setBackgroundImage(#imageLiteral(resourceName: "Radio-1"), for: .normal)
        //            arabicSelection.setImage(UIImage.init(named: "Radio-2"), for: .normal)
        //
        //            englishSelection.setImage(UIImage.init(named: "RadioSelected-1"), for: .normal)
        //        }
    }
    
    
    override func viewDidLayoutSubviews() {
        oltFriendRequest.isOn = false
        oltComments.isOn = false
        oltPostLike.isOn = false
        oltPostShare.isOn = false
        oltRequestAccepted.isOn = false
        self.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "App Settings".localized
        addBackButton()
        
        
        if lang == "ar" {
            //arabicSelection.setBackgroundImage(#imageLiteral(resourceName: "RadioSelected"), for: .normal)
            arabicSelection.setImage(UIImage.init(named: "RadioSelected-1"), for: .normal)
            englishSelection.setImage(UIImage.init(named: "Radio-2"), for: .normal)
        }
        else {
            //            arabicSelection.setBackgroundImage(#imageLiteral(resourceName: "Radio-1"), for: .normal)
            arabicSelection.setImage(UIImage.init(named: "Radio-2"), for: .normal)
            
            englishSelection.setImage(UIImage.init(named: "RadioSelected-1"), for: .normal)
        }
        
        
    }
    // MARK: - Custom
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    
    
    @objc func arabicBtnAction(_ button:UIButton) {
        self.changeLanguage = true
        arabicSelection.setImage(UIImage.init(named: "RadioSelected-1"), for: .normal)
        englishSelection.setImage(UIImage.init(named: "Radio-2"), for: .normal)
        //        UserDefaults.standard.set("ar", forKey: "i18n_language")
        //        //self.appDelegate.moveToHome()
        //        self.appDelegate.loginUser()
    }
    
    @objc func englishBtnAction(_ button:UIButton) {
        self.changeLanguage = false
        arabicSelection.setImage(UIImage.init(named: "Radio-2"), for: .normal)
        
        englishSelection.setImage(UIImage.init(named: "RadioSelected-1"), for: .normal)
        //        UserDefaults.standard.set("en", forKey: "i18n_language")
        //        //self.appDelegate.moveToHome()
        //        self.appDelegate.loginUser()
    }
    
    
    
    func setupViews (){
        if objUser?.notifiyFriendRequest == true{
            oltFriendRequest.isOn = true
            isFriendRequest = 1
        }else{
            oltFriendRequest.isOn = false
            isFriendRequest = 0
        }
        if objUser?.notifiyPostComment == true{
            oltComments.isOn = true
            isPostComment = 1
        }else{
            oltComments.isOn = false
            isPostComment = 0
        }
        if objUser?.notifiyPostLike == true{
            oltPostLike.isOn = true
            isPostLike = 1
        }else{
            oltPostLike.isOn = false
            isPostLike = 0
        }
        if objUser?.notifiyPostShare == true{
            oltPostShare.isOn = true
            isPostShare = 1
        }else{
            oltPostShare.isOn = false
            isPostShare = 0
        }
        if objUser?.notifiyRequestAccepted == true{
            oltRequestAccepted.isOn = true
            isRequestAccepted = 1
        }else{
            oltRequestAccepted.isOn = false
            isRequestAccepted = 0
        }
        
        
    }
    
    
    // MARK: - Api Calls
    func addUserInfo()
    {
        
        self.showLoader()
        let parameters : [String: Any]
        
        parameters  = [
            "notifiy_friend_request": isFriendRequest,
            "notifiy_request_accepted": isRequestAccepted,
            "notifiy_post_like": isPostLike,
            "notifiy_post_comment": isPostComment,
            "notifiy_post_share": isPostShare
        ]
        UserHandler.editUserInfo(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200) {
                
                UserHandler.sharedInstance.userData?.notifiyPostLike = success.data.notifiyPostLike
                UserHandler.sharedInstance.userData?.notifiyPostShare = success.data.notifiyPostShare
                UserHandler.sharedInstance.userData?.notifiyPostComment = success.data.notifiyPostComment
                UserHandler.sharedInstance.userData?.notifiyFriendRequest = success.data.notifiyPostLike
                UserHandler.sharedInstance.userData?.notifiyRequestAccepted = success.data.notifiyPostLike
                
                self.stopAnimating()
                
            }
            else{
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: { 
                })
                self.present(alertView, animated: true, completion: nil)
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
            
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func actionFriendRequest(_ sender: Any) {
        
        if oltFriendRequest.isOn{
            isFriendRequest = 1
        }else{
            isFriendRequest = 0
        }
    }
    @IBAction func actionRequestAccepted(_ sender: Any) {
        if oltRequestAccepted.isOn{
            isRequestAccepted = 1
            
        }else{
            isRequestAccepted = 0
        }
    }
    
    @IBAction func actionPostLike(_ sender: Any) {
        if oltPostLike.isOn{
            isPostLike = 1
            
        }else{
            isPostLike = 0
        }
    }
    
    @IBAction func actionPostComment(_ sender: Any) {
        if oltComments.isOn{
            isPostComment = 1
        }else{
            isPostComment = 0
        }
    }
    
    @IBAction func actionPostShare(_ sender: Any) {
        if oltPostShare.isOn{
            isPostShare = 1
            
        }else{
            isPostShare = 0
        }
    }
}

// MARK: - Extensions
extension AppSettingsController {
    func addRightButton() {
        //        let editButton = UIBarButtonItem(image: #imageLiteral(resourceName: "tick"), style: .plain, target: self, action: #selector(ontickButtonClick))
        //        navigationItem.rightBarButtonItem  = editButton
        
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        menuButton.addTarget(self, action: #selector(ontickButtonClick), for: .touchUpInside)
        let menuItem = UIBarButtonItem(customView: menuButton)
        menuItem.customView?.snp.makeConstraints({ (make) in
            make.width.equalTo(22)
            make.height.equalTo(22)
        })
        
        self.navigationItem.rightBarButtonItem = menuItem
    }
    @objc func ontickButtonClick() {
        addUserInfo()
        
        if(self.changeLanguage == true)
        {
            UserDefaults.standard.set("ar", forKey: "i18n_language")
            //self.appDelegate.moveToHome()
            self.appDelegate.loginUser()
        }else
        {
            UserDefaults.standard.set("en", forKey: "i18n_language")
            //self.appDelegate.moveToHome()
            self.appDelegate.loginUser()
        }
    }
    
}
