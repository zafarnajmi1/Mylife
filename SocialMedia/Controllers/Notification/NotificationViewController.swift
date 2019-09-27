//
//  NotificationViewController.swift
//  SocialMedia
//
//  Created by Apple PC on 16/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import NVActivityIndicatorView
import AVFoundation
import AVKit
let getUnreadNotification_Count = "getUnreadNotificationCount"

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,UITabBarControllerDelegate, NVActivityIndicatorViewable {
    
    
    //let AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let noti = ShareData.sharedUserInfo
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.showsHorizontalScrollIndicator = false
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let notifications = ModelGenerator.generateNotificationModel()
    var arrayNotification = [MyNotificationsData]()
    var paging : MyNotificationsPagination?
    var refreshControl: UIRefreshControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
       
        
        self.title = "My Life".localized
        
        let messageButton = UIButton(type: .custom)
     //   messageButton.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
        messageButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        messageButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let messageItem = UIBarButtonItem(customView: messageButton)
        
        let searchButton = UIButton(type: .custom)
     //   searchButton.addTarget(self, action: #selector(segueToSearchController), for: .touchUpInside)
        searchButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let searchItem = UIBarButtonItem(customView: searchButton)
        
        self.navigationItem.setRightBarButtonItems([messageItem, searchItem], animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
       // ReadAllNotifications()
         getNotifications()
   NotificationCenter.default.addObserver(self, selector: #selector(self.deleteAll), name: NSNotification.Name(rawValue: "serverCallForDelete"), object: nil)
        self.tabBarController?.tabBar.items?[0].title = ""
        self.tabBarController?.tabBar.items?[1].title = ""
        self.tabBarController?.tabBar.items?[2].title = ""
        addRightBarItem()
    }
    
    @objc func deleteAll(notif: NSNotification) {
        //Insert code here
        self.arrayNotification.removeAll()
        self.tableView.reloadData()
       
        //   print("test")
    }
    
    func addRightBarItem() {
        let messageButton = UIButton(type: .custom)
       // messageButton.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
        messageButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        messageButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let messageItem = UIBarButtonItem(customView: messageButton)
        
        
        
        let messageButton2 = UIButton(type: .custom)
        // messageButton.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
        messageButton2.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        messageButton2.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let messageItem2 = UIBarButtonItem(customView: messageButton2)
        
        
        let searchButton = UIButton(type: .custom)
       // searchButton.addTarget(self, action: #selector(segueToSearchController), for: .touchUpInside)
        searchButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let searchItem = UIBarButtonItem(customView: searchButton)
        
        self.navigationItem.setRightBarButtonItems([messageItem, messageItem2,searchItem], animated: true)
    }
    // MARK: - Custom
    func setupViews (){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: -20, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh(sender: AnyObject) {
        arrayNotification.removeAll()
        tableView.reloadData()
        getNotifications()
    }

    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    // MARK: - TableViewDelegates
    func numberOfSections(in tableView: UITableView) -> Int {
       
        
        if arrayNotification.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Notifications found".localized + "\n" + "Pull to refresh".localized
            noDataLabel.textColor     = UIColor(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 16)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            let backgroundimageview = UIImageView(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 190, width: 70, height: 70))
            backgroundimageview.image = #imageLiteral(resourceName: "refresh")
            tableView.backgroundView?.addSubview(backgroundimageview)
            tableView.separatorStyle  = .none
        }else{
            tableView.backgroundView = nil
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotification.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.className, for: indexPath) as! NotificationTableViewCell
        
        if indexPath.row == arrayNotification.count - 2  {
            self.getNextNotifications()

        }
 
 
        
        let notification = arrayNotification[indexPath.row]
        
       
        guard notification.user != nil else {
            return cell
        }
        print(notification.type)
//        ('friend_request','request_accepted','follower','post_comment','post_like','post_share')
        if notification.type == "request_accepted" {
            cell.notificationType.text = notification.title.localized
            cell.nameSenderNotification.text = notification.user.fullName
            cell.notificationDescription.text = notification.descriptionField.localized
            print("Sir = ",notification.descriptionField.localized)
            cell.backgroundColor = UIColor.white
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(notification.createdAt.toDouble))
            let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
            cell.labelTime.text = date
        }
        else  if notification.type == "follower" {
            cell.notificationType.text = notification.title.localized
            cell.nameSenderNotification.text = notification.user.fullName
            cell.notificationDescription.text = notification.descriptionField.localized
            cell.backgroundColor = UIColor.white
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(notification.createdAt.toDouble))
            let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
            cell.labelTime.text = date

        }
        else  if notification.type == "friend_request"{
            cell.notificationType.text = notification.title.localized
            if (notification.user == nil) {
                cell.nameSenderNotification.text = ""
            } else {
                cell.nameSenderNotification.text = notification.user.fullName
            }
            cell.notificationDescription.text = notification.descriptionField.localized
            cell.backgroundColor = UIColor.white
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(notification.createdAt.toDouble))
            let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
            cell.labelTime.text = date
        
        }
        else if notification.type == "post_like"{
            cell.notificationType.text = notification.title.localized
            cell.nameSenderNotification.text = notification.user.fullName
            let longString = notification.descriptionField + " post".localized
            let longestWord = "post"
            let longestWordRange = (longString as NSString).range(of: longestWord)
            let attributedString = NSMutableAttributedString(string: longString)
            attributedString.setAttributes([NSAttributedString.Key.font : UIFont.semiBold], range: longestWordRange)
            cell.notificationDescription.attributedText = attributedString
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(notification.createdAt.toDouble))
            let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
            cell.labelTime.text = date
            cell.backgroundColor = UIColor.white
        }
        else if notification.type == "post_comment"{
            cell.notificationType.text = notification.title.localized
            
            cell.nameSenderNotification.text = notification.user.fullName
            let longString = notification.descriptionField.localized + " post".localized
            let longestWord = "post"
            
            let longestWordRange = (longString as NSString).range(of: longestWord)
            let attributedString = NSMutableAttributedString(string: longString)
            attributedString.setAttributes([NSAttributedString.Key.font : UIFont.semiBold], range: longestWordRange)
            cell.notificationDescription.attributedText = attributedString
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(notification.createdAt.toDouble))
            let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
            cell.labelTime.text = date
            cell.backgroundColor = UIColor.white
        }
        else if notification.type == "post_share"{
            cell.notificationType.text = notification.title.localized
            cell.nameSenderNotification.text = notification.user.fullName
            let longString = notification.descriptionField + " post".localized
            let longestWord = "post"
            
            let longestWordRange = (longString as NSString).range(of: longestWord)
            let attributedString = NSMutableAttributedString(string: longString)
            attributedString.setAttributes([NSAttributedString.Key.font : UIFont.semiBold], range: longestWordRange)
            cell.notificationDescription.attributedText = attributedString
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(notification.createdAt.toDouble))
            let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
            cell.labelTime.text = date
            cell.backgroundColor = UIColor.white
        }else if notification.type == "permanent_story_saved"{
            print("saved story notification")
            cell.notificationType.text = notification.title.localized
             cell.notificationDescription.text = notification.descriptionField.localized
            cell.nameSenderNotification.text = ""
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(notification.createdAt.toDouble))
            let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
            cell.labelTime.text = date
            cell.backgroundColor = UIColor.white
        }
        
        if let coverUrl = notification.user.image {
            var newimage = #imageLiteral(resourceName: "user")
            newimage = newimage.tint(with: UIColor.lightGray)!
            cell.imageViewProfilePicture.sd_setImage(with: URL(string: coverUrl), placeholderImage: newimage)
            cell.imageViewProfilePicture.sd_setShowActivityIndicatorView(true)
            cell.imageViewProfilePicture.sd_setIndicatorStyle(.gray)
            cell.imageViewProfilePicture.contentMode = .scaleAspectFill
            cell.imageViewProfilePicture.clipsToBounds = true
        }else{
            var newimage = #imageLiteral(resourceName: "user")
            newimage = newimage.tint(with: UIColor.lightGray)!

            cell.imageViewProfilePicture.image = newimage
        }
        
        
        
        if (notification.isRead == true)
        {
            cell.backgroundColor = UIColor.white
        }
        else
        {
            let overAllBackGroundColor = UIColor(red:239/255, green:239/255, blue:244/255, alpha: 1)
            cell.backgroundColor = overAllBackGroundColor
        }
        
        

        cell.delegate = self as TapOnName
        cell.labelTime.font = CommonMethods.getFontOfSize(size: 12)
        
        cell.btnDelete.setTitle("Delete".localized, for: .normal)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteButtonAction(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notification = arrayNotification[indexPath.row]
        
        if (notification.isRead != true)
        {
            print("read notification -- ")
            
            self.marknotificationAsRead(notification_id: "\(notification.id!)")
        }
    
        if notification.type == "post_comment" || notification.type == "post_share" || notification.type == "post_like"{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "showPostViewController") as! showPostViewController
            controller.postId = notification.extra.toString
            self.present(controller, animated: true, completion: nil)
        }else if notification.type == "friend_request" {
            tabBarController!.selectedIndex = 1
        }else if notification.type == "request_accepted" || notification.type == "follower" {
            
            let objOwnUser = UserHandler.sharedInstance.userData
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            if objOwnUser?.id != notification.senderId{
                controller.isFromOtherUser = true
                controller.otherUserId = (notification.senderId)
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    @objc func deleteButtonAction(_ sender : UIButton){
        print("sender",sender.tag)
        let alertController = UIAlertController(title:"Delete Notification".localized,message:"Do you want to clear notification".localized, preferredStyle: .alert)
        let OkAction = UIAlertAction(title:"OK".localized,style: .default){UIAlertAction in
            print("ok button pressed")
            self.serverCallForDelete(index:sender.tag)
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
    func serverCallForDelete(index:Int){
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
        
        var parameters : [String: Any]
        parameters = [
            "notification_id" : (self.arrayNotification[index] ).id!
        ]
        print("parameters", parameters)
        
        var url:String?
        
         let lang = UserDefaults.standard.string(forKey: "i18n_language")
        if lang == "ar" {
             url = ApiCalls.baseUrlBuildAR +  ApiCalls.RemoveNotification
        }
        else {
             url = ApiCalls.baseUrlBuild +  ApiCalls.RemoveNotification
        }
        
        
        print("save  favourtie story url",url)
        
        Alamofire.request(url!, method: .post , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    
                    self.showAlrt(message: "Successfully Delete".localized)
                    print("success")
                    self.arrayNotification.remove(at: index)
                    self.tableView.reloadData()
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
    //MARK: - API CALLS
    //MARK: - GET My Notifications
    func getNotifications() {
        self.showLoader()
        UserHandler.getMyNotifications(success: { (success) in
            
            self.stopAnimating()
            if (success.statusCode == 200){
                
                if success.data != nil
                {
                    self.arrayNotification = success.data
                    print(success.data)
                    self.paging = success.pagination
                    if self.arrayNotification.count > 0
                    {
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }else{
                        self.refreshControl.endRefreshing()
                    }

                }else{
                    //self.stopAnimating()
                   // self.displayAlertMessage("You Have No New Notification")
                }
            }else{
                //self.stopAnimating()
                self.displayAlertMessage(success.message)
            }
        })
        { (error) in
            print("error = ",error!)
            
            //self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
        }
    }
    
    
    
    func ReadAllNotificaftions() {
        self.showLoader()
        UserHandler.readAllNotifications(success: { (success) in
            
            self.stopAnimating()
           
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)

           
            if (success.statusCode == 200){
                
                self.noti.notification_count = 0
                UIApplication.shared.applicationIconBadgeNumber = 0
              //  self.AppDelegate.notification_count = 0
               // self.getUnreadNotificationCount()
//                if success.data != nil{
//                    self.arrayNotification = success.data
//                    self.paging = success.pagination
//                    if self.arrayNotification.count > 0 {
//                        self.tableView.reloadData()
//                        self.refreshControl.endRefreshing()
//                    }else{
//                        self.refreshControl.endRefreshing()
//                    }
//
//                }else{
//                    //self.stopAnimating()
//                    // self.displayAlertMessage("You Have No New Notification")
//                }
//            }else{
               // self.stopAnimating()
//                self.displayAlertMessage(success.message)
    }
        })
        { (error) in
            print("error = ",error!)
            
          //self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
        }
    }
    
   
    func getNextNotifications() {
        guard let url = paging?.nextPageUrl else {
            return
        }
        
        if (paging?.currentPage == paging?.lastPage) {
            return
        }
        
        self.showLoader()
        UserHandler.getNextMyNotifications(url: url as! String, success: { (success) in
            
            self.stopAnimating()
            if (success.statusCode == 200){
                if success.data != nil{
                    
                    self.arrayNotification.append(contentsOf: success.data)
                    self.paging = success.pagination
                    self.tableView.reloadData()
                    if self.arrayNotification.count > 0 {
                        //                        self.refreshControl.endRefreshing()
                    }else{
                        //                        self.refreshControl.endRefreshing()
                    }
                    
                }else{
                    //self.stopAnimating()
                    // self.displayAlertMessage("You Have No New Notification")
                }
            }else{
                //self.stopAnimating()
                //                self.displayAlertMessage(success.message)
            }
        }) { (error) in
            print("error = ",error!)
        }
    }
    
    //MARK: - Mark Notification As Read
    func marknotificationAsRead(notification_id: String)
    {
        self.showLoader()
        let parameters : [String: Any] = ["notification_id" : notification_id ]
        UserHandler.markNotificationAsRead(params: parameters as NSDictionary , success: { (success) in
            if(success.statusCode == 200)
            {
                //self.stopAnimating()
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: getUnreadNotification_Count), object: nil)
                self.getUnreadNotificationCount()
            }
            else
            {
                //self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error", message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
            }
        })
        { (error) in
            print("error = ",error!)
           self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            //self.stopAnimating()
        }
    }
    
    func getUnreadNotificationCount() {
        
        UserHandler.getUnreadNotificationCount(success: { (success) in
            
            if (success.statusCode == 200) {
                
                if success.data != nil {
                    String(success.data.unreadNotification!)
                    
                    UIApplication.shared.applicationIconBadgeNumber = success.data.unreadNotification!
                    
                    if(success.data.unreadNotification! == 0)
                    {
                        let tabItems = self.tabBarController?.tabBar.items as NSArray!
                        let tabItem = tabItems![2] as! UITabBarItem
                        tabItem.badgeValue = nil
                    }
                    else
                    {
                        let tabItems = self.tabBarController?.tabBar.items as NSArray!
                        let tabItem = tabItems![2] as! UITabBarItem
                        tabItem.badgeValue = String(success.data.unreadNotification!)
                    }

                }
                else {
                    //  self.view.makeToast("You Have No New Notification", duration: 2.0, position: .center)
                    
                }
            }
            else
            {
                UIApplication.shared.applicationIconBadgeNumber = 0
                //self.view.makeToast(success.message, duration: 2.0, position: .center)
            }
        }) { (error) in
            UIApplication.shared.applicationIconBadgeNumber = 0
            //            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.")
            //
            //            self.displayAlertMessage(String(describing: error!))
            
        }
    }
    
    
}
extension NotificationViewController: TapOnName{
    
    func sendInedNumber(cell: NotificationTableViewCell){
        
        let item = tableView.indexPath(for: cell)
        let getUserId = arrayNotification[item!.item].user.id
        
        let objOwnUser = UserHandler.sharedInstance.userData
       
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        if objOwnUser?.id != getUserId{
            controller.isFromOtherUser = true
            controller.otherUserId = (getUserId)!
        }
                self.navigationController?.pushViewController(controller, animated: true)
//        self.present(controller, animated: false, completion: nil)
    }
}

// MARK: - Video Delegates - Protocols
protocol TapOnName {
    
    func sendInedNumber(cell: NotificationTableViewCell)
   
}

class NotificationTableViewCell: UITableViewCell {
    
    var delegate: TapOnName!
    
    @IBOutlet var imageViewProfilePicture: UIImageView! {
        didSet{
            imageViewProfilePicture.roundWithClear()
        }
    }
    
    @IBOutlet weak var notificationType: UILabel!
    
    @IBOutlet weak var notificationDescription: UILabel!
    @IBOutlet weak var nameSenderNotification: UILabel!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet weak var btnDelete: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userNameTap(tapGestureRecognizer:)))
        nameSenderNotification.isUserInteractionEnabled = true
        nameSenderNotification.addGestureRecognizer(tapGestureRecognizer)
        
        selectionStyle = .none
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    @objc func userNameTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.sendInedNumber(cell:self)
    }
}

struct NotificationModel {
    var name: String
    var notificationText: String
    var time: Date
}
