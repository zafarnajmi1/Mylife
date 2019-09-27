//
//  MainHomeTabController.swift
//  SocialMedia
//
//  Created by iOSDev on 11/3/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Material
import Hero
import UIKit
import NVActivityIndicatorView
import Alamofire
import NVActivityIndicatorView
import AVFoundation
import AVKit
import SocketIO
import MIBadgeButton_Swift



protocol chnageFriendRequestNotificationsCount {
   func getAllFriends()
   
}

class MainHomeTabController: UITabBarController, UINavigationControllerDelegate,chnageFriendRequestNotificationsCount,UITabBarControllerDelegate ,NVActivityIndicatorViewable{
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var socket:SocketIOClient!
    var manager:SocketManager!
 var oltNotification: MIBadgeButton?
    var navigationDrawer: AppNavigationDrawerController?
    let prefs = UserDefaults.standard
    var arrayUnReadNotificationCont = [UnreadNotificationCoutData]()
    let user = SharedData.sharedUserInfo
    
    var flag = true

  
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
   
      //  print("Selected Index 2 :\( self.tabBar.selectedIndex)");
        print("the selected index is : \(String(describing: tabBar.items!.index(of: item)))")

      
        if (tabBar.items?.index(of: item) == 2) {
        
             addRightBarItem1()
            flag = false
              print("Selected Index 2 :\(self.selectedIndex)");
        }
        if(tabBar.items?.index(of: item) == 1){
              print("Selected Index 0 :\(self.selectedIndex)");
            addRightBarItem()
            flag = true
        }
        if(tabBar.items?.index(of: item) == 0){
              print("Selected Index 1:\(self.selectedIndex)");
            addRightBarItem()
            flag = true
        }
       
        
    }
    
     let friendRequestViewController = FriendRequestsViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       friendRequestViewController.delegate = self
        self.navigationDrawer?.isLeftPanGestureEnabled = false
        getUnreadNotificationCount()
        getUnreadMessageCount()
        getAllFriends()
        isMotionEnabled = true
        self.tabBarController?.delegate = self
        transitionCover()
        getAllEmoji()
        
        hitConversation()
      
       
        
       
        
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
            
            
            self.manager = SocketManager(socketURL: URL(string:  ApiCalls.baseUrlSocket)! , config: specs)
            
            self.socket = manager.defaultSocket
            
//            self.socket  = SocketIOClient(
//                socketURL: NSURL(string: ApiCalls.baseUrlSocket)! as URL as URL,
//                config: specs)
            
            
            
            self.socket.on("connected") { (data, ack) in
                if let arr = data as? [[String: Any]] {
                    if let txt = arr[0]["text"] as? String {
                        print(txt)
                    }
                }
                
            }
          
            
            self.socket.on("newPost") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
               //  self.getUnreadNotificationCount()
                //  self.socket.emit("conversationsList")
                
            }
            
            self.socket.on("newNotification") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                self.getUnreadNotificationCount()
                self.getUnreadMessageCount()
                  self.getAllFriends()
                print(dictionary)
                //  self.socket.emit("conversationsList")
                
            }
            //
            
            self.socket.on(clientEvent: .connect) {data, emitter in
                // handle connected
             //   self.socket.emit("userLoggedin")
                
                
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideBackButton()
        addTitle()
        
        
            //addrightArBarItem()
        
           addLeftBarItem()
        
        
        if(flag){
        addRightBarItem()
        }
        else{
        addRightBarItem1()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.nameOfFunction), name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(self.friendNotification), name: NSNotification.Name(rawValue: "friendNotification"), object: nil)
    }
    @objc func nameOfFunction(notif: NSNotification) {
        //Insert code here
        getUnreadNotificationCount()
     //   print("test")
    }
    
    @objc func friendNotification(notif: NSNotification) {
       getAllFriends()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideLeftBarItem()
        hideRightBarItem()
    }
    
    func getUnreadMessageCount() {
        /*
         Timer.after(15.seconds){
         self.getUnreadNotificationCount()
         }*/
        
        UserHandler.getUnreadMessageCount(success: { (success) in
            
            if (success.statusCode == 200)
            {
                if success.data != nil
                {
                   
                    if String(success.data.unread!) != "0" {
                        if(self.flag)
                        {
                             self.oltNotification = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
                             self.oltNotification!.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
                             self.oltNotification?.badgeString = String(success.data.unread!)
                             self.oltNotification!.addTarget(self, action: #selector( self.segueToMessagesController), for: .touchUpInside)
                            let messageItem = UIBarButtonItem(customView:  self.oltNotification!)
                            
                            self.oltNotification!.badgeEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
                            //        let messageButton = UIButton(type: .custom)
                            //        messageButton.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
                            //        messageButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
                            //        messageButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                            //        let messageItem = UIBarButtonItem(customView: messageButton)
                            
                            let searchButton = UIButton(type: .custom)
                            searchButton.addTarget(self, action: #selector( self.segueToSearchController), for: .touchUpInside)
                            searchButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
                            searchButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                            let searchItem = UIBarButtonItem(customView: searchButton)
                            
                            self.navigationItem.setRightBarButtonItems([messageItem, searchItem], animated: true)
                        }
                        else{
                            self.oltNotification = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
                              self.oltNotification!.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
                            // oltNotification?.badgeString = "1"
                              self.oltNotification?.badgeString = String(success.data.unread!)
                              self.oltNotification!.addTarget(self, action: #selector(  self.segueToMessagesController), for: .touchUpInside)
                            let messageItem = UIBarButtonItem(customView:   self.oltNotification!)
                            self.oltNotification!.badgeEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
                            
                            let searchButton = UIButton(type: .custom)
                            searchButton.addTarget(self, action: #selector(  self.segueToSearchController), for: .touchUpInside)
                            searchButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
                            searchButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                            let searchItem = UIBarButtonItem(customView: searchButton)
                            
                            let deleteButton = UIButton(type: .custom)
                            deleteButton.addTarget(self, action: #selector(  self.deleteButtonAction), for: .touchUpInside)
                            deleteButton.setImage(#imageLiteral(resourceName: "Delete-1"), for: .normal)
                            deleteButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                            let deleteItem = UIBarButtonItem(customView: deleteButton)
                            //  messageItem.badgeValue = String("self.arrayDataMyFriendRequest.count")
                            // deleteButton.badgeString = "120"
                            
                            self.navigationItem.setRightBarButtonItems([deleteItem,messageItem, searchItem], animated: true)
                        }
                    }
                    else{
                        if(self.flag){
                            self.addRightBarItem()
                        }
                        else{
                            self.addRightBarItem1()
                        }
                       
                    }
                    
                }
                else
                {
                    //  self.view.makeToast("You Have No New Notification", duration: 2.0, position: .center)
                }
            }
            else
            {
                //self.view.makeToast(success.message, duration: 2.0, position: .center)
            }
            
        })
        { (error) in
            print("error = ",error!)
            
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
        }
    }
    //MARK: - GET Unread Notification Count
    func getUnreadNotificationCount() {
        /*
        Timer.after(15.seconds){
            self.getUnreadNotificationCount()
        }*/

        UserHandler.getUnreadNotificationCount(success: { (success) in
            
            if (success.statusCode == 200)
            {
                if success.data != nil
                {
                    let tabItems = self.tabBar.items as NSArray!
                    let tabItem = tabItems![2] as! UITabBarItem
                    if String(success.data.unreadNotification!) != "0"
                    {
                             tabItem.badgeValue = String(success.data.unreadNotification!)
                        UIApplication.shared.applicationIconBadgeNumber = success.data.unreadNotification!
                    }
                    else{
                          tabItem.badgeValue = nil;
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                    
                }
                else
                {
                    //  self.view.makeToast("You Have No New Notification", duration: 2.0, position: .center)
                }
            }
            else
            {
                //self.view.makeToast(success.message, duration: 2.0, position: .center)
            }
            
        })
        { (error) in
            print("error = ",error!)
            
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
        }
    }
     //MARK: - GET Friend Request Notification Count
    func updateCartBadge (_ notification: NSNotification){
     
    }
    var  arrayDataMyFriendRequest  = [MyFriendRequestData]()
    func getAllFriends()
    {
       
        FriendsHandler.myFriendRequest(success: { (successResponse) in
           
            if (successResponse.statusCode == 200){
                self.arrayDataMyFriendRequest = successResponse.data
                
                
                
                print(self.arrayDataMyFriendRequest)
                let tabItems = self.tabBar.items as NSArray!
                let tabItem = tabItems![1] as! UITabBarItem
                if self.arrayDataMyFriendRequest.count > 0 {
                  
                    tabItem.badgeValue = String(self.arrayDataMyFriendRequest.count)
                    
                   
                }else{
                  tabItem.badgeValue = nil;
                }
               
            }
            else{
                self.displayAlertMessage(successResponse.message)
                
            }
            
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
        }
    }
    
    func getAllEmoji()
    {
        
        FriendsHandler.EmojiRequest(success: { (successResponse) in
            
        
              // print (successResponse.data)
            self.user.EmojiArray = (successResponse.data?.emoji)!
                
                  print (self.user.EmojiArray)
               // print(self.arrayDataMyFriendRequest)
                
//                if self.arrayDataMyFriendRequest.count > 0 {
//                    let tabItems = self.tabBar.items as NSArray!
//                    let tabItem = tabItems![1] as! UITabBarItem
//                    tabItem.badgeValue = String(self.arrayDataMyFriendRequest.count)
            
               
                
          
        
            
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension MainHomeTabController: LeftViewControllerDelegate {
    func onBlockUserListClicked() {
        let vc = UIStoryboard.mainStoryboard.instantiateVC(BlockUserListVC.self)!
        let controller = embedIntoNavigationController(vc)
        
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
    
    func onAppSettingClicked() {
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(AppSettingsController.self)!
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

    func onSavedStoriesClicked() {
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(SavedStoriesPermanentlyViewController.self)!
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
            
        })
        { (error) in
            print("error = ",error!)
            // self.view.hideToastActivity()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
            
        }
    }
}

extension MainHomeTabController {
    func embedIntoNavigationController(_ rootController: UIViewController, presentingTransition: HeroDefaultAnimationType = .pageIn(direction: .left), dismissTransition: HeroDefaultAnimationType = .pageOut(direction: .right)) -> UINavigationController {
        rootController.isHeroEnabled = true
        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.view.backgroundColor = .white
        navigationController.isHeroEnabled = true
        navigationController.heroModalAnimationType = .selectBy(presenting: presentingTransition, dismissing: dismissTransition)
        
        return navigationController
    }
    
    fileprivate func transitionCover() {
        motionTransitionType = .autoReverse(presenting: .cover(direction: .up))
    }
    
    func addTitle() {
        self.title = "My Life".localized
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
     
        
            self.navigationItem.setLeftBarButton(menuItem, animated: true)
        
    }
    
    func addrightArBarItem() {
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        menuButton.addTarget(self, action: #selector(self.toggleNavigationDrawer), for: .touchUpInside)
        let menuItem = UIBarButtonItem(customView: menuButton)
        
        menuItem.customView?.snp.makeConstraints({ (make) in
            make.width.equalTo(22)
            make.height.equalTo(22)
        })
        
        
        self.navigationItem.setRightBarButton(menuItem, animated: true)
        
    }
    
    func hideRightBarItem() {
        self.navigationItem.rightBarButtonItems = nil
    }
    
    func hideLeftBarItem() {
        self.navigationItem.leftBarButtonItems = nil
    }
    
//    func addHomeBarButtons() {
//
//        let imageNotifications = UIImage(named: "Notification")
//        let tintedImageNotification = imageNotifications?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        oltNotification = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 23, height: 23))
//        oltNotification!.setImage(tintedImageNotification, for: .normal)
//        oltNotification?.badgeString = "20"
//        oltNotification!.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
//        let notifyItem = UIBarButtonItem(customView: oltNotification!)
//
//            oltNotification!.badgeEdgeInsets = UIEdgeInsetsMake(7, 0, 0, 0)
//
//        let imageSearch = UIImage (named: "Search")
//        let searchTintedImage = imageSearch?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        let searchButton = UIButton(type: .custom)
//        searchButton.setImage(searchTintedImage, for: .normal)
//        searchButton.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
//        searchButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
//        let searchItem = UIBarButtonItem(customView: searchButton)
//
//        self.navigationItem.setRightBarButtonItems([notifyItem, searchItem], animated: true)
//    }
    func addRightBarItem1() {
        
        
     //   let imageNotifications = UIImage(named: "Notification")
     //   messageButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)

     //   let tintedImageNotification = imageNotifications?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        oltNotification = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        oltNotification!.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
       // oltNotification?.badgeString = "1"
           oltNotification?.badgeString = nil
        oltNotification!.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
        let messageItem = UIBarButtonItem(customView: oltNotification!)
        oltNotification!.badgeEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        
        let searchButton = UIButton(type: .custom)
        searchButton.addTarget(self, action: #selector(segueToSearchController), for: .touchUpInside)
        searchButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let searchItem = UIBarButtonItem(customView: searchButton)
        
        let deleteButton = UIButton(type: .custom)
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        deleteButton.setImage(#imageLiteral(resourceName: "Delete-1"), for: .normal)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let deleteItem = UIBarButtonItem(customView: deleteButton)
        //  messageItem.badgeValue = String("self.arrayDataMyFriendRequest.count")
       // deleteButton.badgeString = "120"

        self.navigationItem.setRightBarButtonItems([deleteItem,messageItem, searchItem], animated: true)
        //  self.navigationItem.rightBarButtonItems.badgeValue
    }
    
    @objc func deleteButtonAction(){
        let alertController = UIAlertController(title:"Clear Notification".localized,message:"Do you want to clear notification".localized, preferredStyle: .alert)
        let OkAction = UIAlertAction(title:"OK".localized,style: .default){UIAlertAction in
            print("ok button pressed")
            self.serverCallForDelete()
        }
        let cancelAction = UIAlertAction(title:"Cancel".localized,style: .default){UIAlertAction in
            print("cancel button pressed")
        }
        alertController.addAction(OkAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    func serverCallForDelete(){
        self.showLoader()
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken  //"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        //        let objUser = UserHandler.sharedInstance.userData
        //        var userID: Int = (objUser?.id)!
        //        print("user id ",userID)
        
      
        let url = ApiCalls.baseUrlBuild +  ApiCalls.allRemoveNotification
        
        print("save  favourtie story url",url)
        
        Alamofire.request(url, method: .get , parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                   
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "serverCallForDelete"), object: nil)

                   


                    self.showAlrt(message: "Successfully Clear".localized)
                    print("success")
                
                    self.stopAnimating()
                    
                }
                self.stopAnimating()
            case .failure(let error):
                print("RESPONSE ERROR: \(error)")
                self.stopAnimating()
                self.showAlrt(message: "RESPONSE ERROR: \(error)")
                
            }
        }
        
    }
    func addRightBarItem() {
        oltNotification = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        oltNotification!.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        oltNotification?.badgeString = nil
        oltNotification!.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
        let messageItem = UIBarButtonItem(customView: oltNotification!)
        oltNotification!.badgeEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
//        let messageButton = UIButton(type: .custom)
//        messageButton.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
//        messageButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
//        messageButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
//        let messageItem = UIBarButtonItem(customView: messageButton)
        
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
             //UIView.appearance().semanticContentAttribute = .forceRightToLeft
            navigationDrawer?.toggleRightView(velocity: 0.5)
        }
        else {
            navigationDrawer?.toggleLeftView(velocity: 0.5)
        }
        
        //navigationDrawer?.toggleLeftView(velocity: 0.5)
        //navigationDrawer?.toggleRightView(velocity: 0.5)
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

