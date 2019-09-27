//
//  HomeTabController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 11/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Material
import Hero

class HomeTabController: UITabBarController, UINavigationControllerDelegate {
    
    let AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var navigationDrawer: AppNavigationDrawerController?
    let prefs = UserDefaults.standard
    var arrayUnReadNotificationCont = [UnreadNotificationCoutData]()
    let noti = ShareData.sharedUserInfo
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected Index :\(self.selectedIndex)");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(getUpdatedNotificationCountStatus), name: NSNotification.Name(rawValue: getUnreadNotification_Count), object: nil)
        
        isMotionEnabled = true
        transitionCover()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUnreadNotificationCount()
        hideBackButton()
        addTitle()
        addLeftBarItem()
        addRightBarItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideLeftBarItem()
        hideRightBarItem()
    }
    
    
    @objc private func getUpdatedNotificationCountStatus() {
       getUnreadNotificationCount()
    }
    
    //MARK: - GET Unread Notification Count
    func getUnreadNotificationCount() {
        
        UserHandler.getUnreadNotificationCount(success: { (success) in
            
            if (success.statusCode == 200) {
                
                if success.data != nil {
                    let tabItems = self.tabBar.items as NSArray!
                    let tabItem = tabItems![2] as! UITabBarItem
                    tabItem.badgeValue = String(success.data.unreadNotification!)
                    
                    self.noti.notification_count = success.data.unreadNotification!
                }
                else {
                  //  self.view.makeToast("You Have No New Notification", duration: 2.0, position: .center)
                   
                }
            }
            else {
               
                //self.view.makeToast(success.message, duration: 2.0, position: .center)
            }
        }) { (error) in
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)

            self.displayAlertMessage(String(describing: error!))
            
        }
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension HomeTabController: LeftViewControllerDelegate {
   
    func onBlockUserListClicked() {
        let vc = UIStoryboard.mainStoryboard.instantiateVC(BlockUserListVC.self)!
        let controller = embedIntoNavigationController(vc)
        
        presentVC(controller) {
            self.closeNavigationDrawer()
        }
    }
    
    func onSavedStoriesClicked() {
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(SavedStoriesPermanentlyViewController.self)!
        let controller = embedIntoNavigationController(profileController)
        
        presentVC(controller) {
            self.closeNavigationDrawer()
        }
    }
    
    func onMyProfileClicked() {
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(UserProfileViewController.self)!
        let controller = embedIntoNavigationController(profileController)
        
        presentVC(controller) {
            self.closeNavigationDrawer()
        }
    }
    
    func onActivityLogClciked() {
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(ActivityLogViewController.self)!
        let controller = embedIntoNavigationController(profileController)
        
        presentVC(controller) {
            self.closeNavigationDrawer()
        }
    }
    
    func onSentRequestClicked() {
     
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(SentRequestViewController.self)!
        let controller = embedIntoNavigationController(profileController)
        
        presentVC(controller) {
            self.closeNavigationDrawer()
        }
    }
    func onAppSettingClicked() {
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(AppSettingsController.self)!
        let controller = embedIntoNavigationController(profileController)
        
        presentVC(controller) {
            self.closeNavigationDrawer()
        }
    }
    
    func onHelplClicked() {
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(HelpViewController.self)!
        let controller = embedIntoNavigationController(profileController)
        
        presentVC(controller) {
            self.closeNavigationDrawer()
        }
    }
    
    func onAboutClicked() {
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(AboutViewController.self)!
        let controller = embedIntoNavigationController(profileController)
        presentVC(controller) {
            self.closeNavigationDrawer()
        }
    }
    
    func onMySchedulesClicked() {
        let mySchedulesViewController = UIStoryboard.mainStoryboard.instantiateVC(MySchedulesViewController.self)!
        let controller = embedIntoNavigationController(mySchedulesViewController)
        
        presentVC(controller) {
            self.closeNavigationDrawer()
        }
    }
    
    func onLogoutClicked() {
        //        toggleNavigationDrawer()
       // self.view.makeToastActivity(.center)
        UserHandler.logoutUser(success: { (success) in
            
            self.prefs.set(nil, forKey: "useremail")
            UserDefaults.standard.synchronize()
            self.prefs.set(nil, forKey: "password")
            UserDefaults.standard.synchronize()
            self.prefs.set("", forKey: "userAuthToken")
           // self.view.hideToastActivity()
            self.movToLogOutController()
            
        }) { (error) in
            print("error = ",error!)
           // self.view.hideToastActivity()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
        }
    }
}

extension HomeTabController {
    func embedIntoNavigationController(_ rootController: UIViewController, presentingTransition: HeroDefaultAnimationType = .pageIn(direction: .left), dismissTransition: HeroDefaultAnimationType = .pageOut(direction: .right)) -> UINavigationController {
        rootController.isHeroEnabled = true
        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.view.backgroundColor = .white
        navigationController.isHeroEnabled = true
        navigationController.heroModalAnimationType = .selectBy(presenting: presentingTransition, dismissing: dismissTransition)
        
        return navigationController
    }
    
    fileprivate func transitionCover() {
        motionTabBarTransitionType = .autoReverse(presenting: .cover(direction: .up))
    }
    
    func addTitle() {
        self.title = "My Life"
    }
    
    func addLeftBarItem() {
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        menuButton.addTarget(self, action: #selector(self.toggleNavigationDrawer), for: .touchUpInside)
        let menuItem = UIBarButtonItem(customView: menuButton)
        
        menuItem.customView?.snp.makeConstraints({ (make) in
            make.width.equalTo(22)
            make.height.equalTo(22)
        })
        
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.navigationItem.setRightBarButton(menuItem, animated: true)
        }
        else {
            self.navigationItem.setLeftBarButton(menuItem, animated: true)
        }
        
        
    }
    
    func hideRightBarItem() {
        self.navigationItem.rightBarButtonItems = nil
    }
    
    func hideLeftBarItem() {
        self.navigationItem.leftBarButtonItems = nil
    }
    
    func addRightBarItem() {
        let messageButton = UIButton(type: .custom)
        messageButton.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
        messageButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        messageButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let messageItem = UIBarButtonItem(customView: messageButton)
        
        let searchButton = UIButton(type: .custom)
        searchButton.addTarget(self, action: #selector(segueToSearchController), for: .touchUpInside)
        searchButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let searchItem = UIBarButtonItem(customView: searchButton)
        
        self.navigationItem.setRightBarButtonItems([messageItem, searchItem], animated: true)
    }
    
    @objc func segueToMessagesController() {
        let postControleller = UIStoryboard.mainStoryboard.instantiateViewController(MessengerViewController.self)!
        postControleller.isHeroEnabled = true
        let controller = UINavigationController(rootViewController: postControleller)
        controller.view.backgroundColor = .white
        controller.isMotionEnabled = true
        controller.isHeroEnabled = true
        controller.heroModalAnimationType = .selectBy(presenting: HeroDefaultAnimationType.push(direction: .left), dismissing: HeroDefaultAnimationType.pull(direction: .right))
        
        presentVC(controller)
        
        //segueTo(controller: .messengerViewController)
    }
    
    @objc func segueToSearchController() {
        let controller = AppSearchBarController(rootViewController: RootViewController())
        controller.isMotionEnabled = true
        controller.motionTransitionType = .autoReverse(presenting: .auto)

//        self.navigationController?.pushViewController(controller, animated: false)
        self.presentVC(controller)
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AppSearchBarController") as! AppSearchBarController
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func toggleNavigationDrawer() {
        if lang == "ar" {
            
            navigationDrawer?.toggleRightView(velocity: 0.5)
        }
        else {
            navigationDrawer?.toggleLeftView(velocity: 0.5)
        }
        
    }
    
    func closeNavigationDrawer() {
        navigationDrawer?.closeLeftView(velocity: 0.1)
    }
    
    func movToLogOutController()
    {
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(LoginViewController.self)!
        presentVC(profileController) {
//            self.closeNavigationDrawer()
        }
    }
}
